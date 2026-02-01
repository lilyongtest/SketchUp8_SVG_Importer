require 'sketchup.rb'

# ==============================================================================
# SVG Importer for SketchUp 8
# Version: 1.4.0 (Stable)
# Description: 高精度な座標計算と、連続するパスを一本の曲線としてインポートする機能を提供します。
# ==============================================================================

module SU8_SVG_Importer_Stable
  def self.import_svg
    path = UI.openpanel("Select SVG File", "~", "*.svg")
    return if path.nil?

    model = Sketchup.active_model
    entities = model.active_entities
    content = File.read(path)
    
    # SVGのパスデータを抽出
    d_data = content.scan(/d\s*=\s*["']([^'"]+)["']/)

    if d_data.empty?
      UI.messagebox("Error: No SVG path data found.")
      return
    end

    model.start_operation("Import SVG Data", true)
    
    # 必要に応じてスケールを調整してください
    scale = 0.1
    
    d_data.each do |d_match|
      path_str = d_match[0]
      tokens = path_str.scan(/[a-zA-Z]|[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?/)
      
      cx, cy = 0.0, 0.0 
      sx, sy = 0.0, 0.0 
      last_c2x, last_c2y = 0.0, 0.0
      last_cmd = nil
      idx = 0
      line_pts = []

      # 描画処理：座標リストからSketchUpの曲線（Curve）を生成
      draw_path = lambda do |pts|
        if pts.length >= 2
          # 重複する近接点を除去して精度を維持
          clean = [pts[0]]
          pts.each { |p| clean << p if (p[0]-clean.last[0]).abs > 0.001 || (p[1]-clean.last[1]).abs > 0.001 }
          entities.add_curve(clean.map{|p| [p[0]*scale, -p[1]*scale, 0]}) if clean.length >= 2
        end
        pts.clear
      end

      while idx < tokens.length
        token = tokens[idx]
        if token =~ /^[a-zA-Z]$/
          cmd = token
          idx += 1
        else
          # SVGコマンドの省略補完
          if last_cmd == "M"; cmd = "L"; elsif last_cmd == "m"; cmd = "l"; else; cmd = last_cmd; end
        end
        break if cmd.nil?

        case cmd
        when "M", "m"
          draw_path.call(line_pts)
          nx, ny = tokens[idx].to_f, tokens[idx+1].to_f
          if cmd == "m"; cx += nx; cy += ny; else; cx = nx; cy = ny; end
          sx, sy = cx, cy
          line_pts << [cx, cy]
          idx += 2
        when "L", "l", "H", "h", "V", "v"
          if cmd =~ /L/i
            nx, ny = tokens[idx].to_f, tokens[idx+1].to_f
            if cmd == "l"; cx += nx; cy += ny; else; cx = nx; cy = ny; end
            idx += 2
          elsif cmd =~ /H/i
            nx = tokens[idx].to_f
            if cmd == "h"; cx += nx; else; cx = nx; end
            idx += 1
          elsif cmd =~ /V/i
            ny = tokens[idx].to_f
            if cmd == "v"; cy += ny; else; cy = ny; end
            idx += 1
          end
          line_pts << [cx, cy]
        when "C", "c", "S", "s"
          draw_path.call(line_pts)
          p1 = [cx, cy]
          if cmd =~ /C/i
            v = (0..5).map{|i| tokens[idx+i].to_f }; idx += 6
            if cmd == "c"
              p2 = [cx+v[0], cy+v[1]]; p3 = [cx+v[2], cy+v[3]]; p4 = [cx+v[4], cy+v[5]]
            else
              p2, p3, p4 = [v[0], v[1]], [v[2], v[3]], [v[4], v[5]]
            end
          else
            v = (0..3).map{|i| tokens[idx+i].to_f }; idx += 4
            p2 = (last_cmd =~ /[cs]/i) ? [2*cx - last_c2x, 2*cy - last_c2y] : [cx, cy]
            if cmd == "s"
              p3 = [cx+v[0], cy+v[1]]; p4 = [cx+v[2], cy+v[3]]
            else
              p3, p4 = [v[0], v[1]], [v[2], v[3]]
            end
          end
          # 3次ベジェ曲線の補間計算
          curve_pts = []
          steps = 12 # 分割数
          (0..steps).each do |i|
            t = i.to_f / steps
            tx = (1-t)**3 * p1[0] + 3*(1-t)**2 * t * p2[0] + 3*(1-t) * t**2 * p3[0] + t**3 * p4[0]
            ty = (1-t)**3 * p1[1] + 3*(1-t)**2 * t * p2[1] + 3*(1-t) * t**2 * p3[1] + t**3 * p4[1]
            curve_pts << [tx*scale, -ty*scale, 0]
          end
          entities.add_curve(curve_pts)
          cx, cy, last_c2x, last_c2y = p4[0], p4[1], p3[0], p3[1]
          line_pts << [cx, cy]
        when "Z", "z"
          line_pts << [sx, sy]
          draw_path.call(line_pts)
          cx, cy = sx, sy
        else
          idx += 1
        end
        last_cmd = cmd
      end
      draw_path.call(line_pts)
    end
    model.commit_operation
    UI.messagebox("SVG Import Completed Successfully.")
  end
end

if not file_loaded?(__FILE__)
  UI.menu("Plugins").add_item("Import SVG (Stable)") { SU8_SVG_Importer_Stable.import_svg }
  file_loaded(__FILE__)
end