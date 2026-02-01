# SVG Importer for SketchUp 8 (Stable Edition)

An advanced SVG import plugin for SketchUp 8, designed with a focus on Bezier curve interpolation and path continuity.
SketchUp 8に標準搭載されていないSVGインポート機能を追加するRubyプラグインです。ベジェ曲線の補完とパスの連続性を重視して設計されています。

---

## 🚀 Features / 特徴

* **High-Precision Bezier Interpolation**: Accurately recreates smooth curves by subdividing cubic Bezier paths.
  * **高精度なベジェ補完**: 三次ベジェ曲線を適切に分割し、滑らかな曲線を再現します。
* **Path Continuity**: Leverages the `add_curve` method to ensure consecutive segments are treated as a single curve entity.
  * **パスの連続性**: `add_curve` メソッドを活用し、連続する線分を一本の曲線として生成します。
* **Broad Command Support**: Supports `M/m`, `L/l`, `H/h`, `V/v`, `C/c`, `S/s`, and `Z/z`.
  * **広範なコマンド対応**: 主要なSVGパスコマンドを網羅しています。
* **Optimized Performance**: Batch processing logic minimizes memory load during import.
  * **最適化された処理**: バッチ描画ロジックにより、メモリ負荷を抑え高速に動作します。

## 📂 Installation / インストール方法

1. Download `svg_importer.rb`.
   `svg_importer.rb` をダウンロードします。
2. Place the file in the SketchUp 8 `Plugins` folder.
   SketchUp 8の `Plugins` フォルダにファイルを配置します。
   - **Windows:** `C:\Program Files (x86)\Google\Google SketchUp 8\Plugins`
   - **macOS:** `/Library/Application Support/Google SketchUp 8/SketchUp/Plugins`
3. Restart SketchUp.
   SketchUpを再起動します。

## 🛠 Usage / 使い方

1. Navigate to **[Plugins] > [Import SVG (Stable)]**.
   メニューの **[Plugins] > [Import SVG (Stable)]** をクリックします。
2. Select your `.svg` file.
   インポートしたい `.svg` ファイルを選択します。
3. Edges/Curves will be generated automatically.
   自動的にエッジや曲線が生成されます。

### Generating Faces / 面を生成するコツ
Imported paths are generated as edges. To create a face, simply trace one of the edges with the **[Line Tool]**.
インポートされた線はエッジの状態です。面を生成したい場合は、外周の一辺を **[鉛筆ツール]** でなぞってください。

## ⚠️ Important Notes / 注意事項

* **File Paths (Non-ASCII Characters)**: 
  Ensure that the **SVG file name and its folder path do not contain 2-byte characters (e.g., Japanese, Chinese, or Korean)**. Using non-ASCII characters in the path may cause the import to fail.
  **SVGファイル名および保存先のフォルダ名に、2バイト文字（日本語など）を含めないでください。** パスに全角文字が含まれていると、正常に読み込めない場合があります。
* **Preparation**: Convert all objects to "Paths" in your design software (Inkscape, Illustrator, etc.) before saving the SVG.
  SVG保存前に、デザインソフトで全てのオブジェクトを「パス」に変換しておくことを推奨します。
* **Scaling**: Default scale is `0.1`. You can modify this in the script.
  デフォルトの倍率は `0.1` です。コード内の `scale = 0.1` を書き換えることで調整可能です。

## 📄 License / ライセンス

This project is released under the MIT License.
このプロジェクトはMITライセンスの下で公開されています。
