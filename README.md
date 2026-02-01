# SVG Importer for SketchUp 8 (Stable Edition)

SketchUp 8 に標準では搭載されていない SVG インポート機能を追加するための Ruby プラグインです。
ベジェ曲線の補完とパスの連続性を重視して設計されており、複雑なシルエットも正確に再現することを目指しています。

## 🚀 特徴 (Features)

* **高精度なベジェ曲線補完**: 三次ベジェ曲線を適切なステップ数で分割し、滑らかな曲線を SketchUp 上に再現します。
* **パスの連続性維持**: `add_curve` メソッドを活用し、連続する線分を一本の「曲線エンティティ」として生成します。
* **広範なコマンド対応**: `M/m` (MoveTo), `L/l` (LineTo), `H/h` (Horizontal), `V/v` (Vertical), `C/c` (Cubic Bezier), `S/s` (Smooth Cubic Bezier), `Z/z` (ClosePath) に対応しています。
* **軽量・高速**: メモリ負荷を抑えるために、パス単位でのバッチ描画ロジックを採用しています。

## 📂 インストール方法 (Installation)

1. `svg_importer.rb` （または本リポジトリのソースコード）をダウンロードします。
2. SketchUp 8 の `Plugins` フォルダにファイルを配置します。
   - **Windows:** `C:\Program Files (x86)\Google\Google SketchUp 8\Plugins`
   - **macOS:** `/Library/Application Support/Google SketchUp 8/SketchUp/Plugins`
3. SketchUp を再起動します。

## 🛠 使い方 (Usage)

1. 上部メニューの **[Plugins] > [Import SVG (Stable)]** をクリックします。
2. ファイル選択ダイアログで `.svg` ファイルを選択します。
3. インポートが完了すると、モデル上にパスが生成されます。

### 面を生成するコツ (Generating Faces)
インポートされた線は「エッジ（曲線）」の状態です。面を生成したい場合は、生成された外周の線の一辺を **[鉛筆ツール]** でなぞってください。SketchUp の標準機能により、閉じたパス内に面が自動生成されます。

## ⚠️ 注意事項 (Caveats)

* **事前準備**: SVG ファイルは、Adobe Illustrator や Inkscape 等で「すべてのオブジェクトをパスに変換」してから保存することを推奨します。
* **スケール**: デフォルトでは `0.1` の倍率でインポートされます。サイズを調整したい場合は、コード内の `scale = 0.1` の値を編集してください。

## 📄 ライセンス (License)

このプロジェクトは MIT ライセンスの下で公開されています。
