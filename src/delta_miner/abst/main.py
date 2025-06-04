import json
import os
import subprocess

from code_abstract import CodeAbstract
from parser import Parser


def execute_abstraction(js_file_path) -> str | None:
    """抽象化実行関数

    Args:
        js_file_path (str): 対象ファイルのパス

    Returns:
        str: 抽象化後のファイル
    """
    # プロセスIDを使用してユニークな一時ファイルを生成
    thread_id = os.getpid()
    target_js = f"./parser_{thread_id}.js"

    try:
        parser = Parser(thread_id)

        # JavaScriptコードを読み込み
        with open(js_file_path, "r") as f:
            code = f.read()

        # 改行コードの標準化・コメント除去・フォーマッタの適応
        code = code.replace("\r\n", "\n")
        # code = parser.remove_comment(code)
        code = parser.prettier(code)

        # 整形後コードが空の場合は終了
        if len(code) == 0:
            return None

        # AST生成
        ast_str = subprocess.run(
            ["node", "jsparser.mjs", target_js],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
        ).stdout

        # ASTが存在しない場合は終了
        if len(ast_str) == 0:
            return None

        # json形式で読み込み
        ast = json.loads(ast_str)

        # 弱抽象化の実施
        abstcode = CodeAbstract(code, ast)
        abstcode.weak_abstract_code()

        # 抽象化結果を返す
        return abstcode.abstract_code
    finally:
        # 一時ファイルの削除
        if os.path.exists(target_js):
            try:
                os.remove(target_js)
            except Exception as e:
                print(f"一時ファイル削除中にエラーが発生しました: {e}")



if __name__ == "__main__":
    result = execute_abstraction("test.sample.js")
    if result is None:
        print("抽象化に失敗しました.")
    else:
        print("抽象化成功.結果を保存します.")
        with open("test_abs.sample.js", "w") as f:
            f.write(result)
