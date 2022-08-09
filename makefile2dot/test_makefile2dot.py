"""
Test the helper functions in makefile2dot.
"""
import io
from contextlib import redirect_stdout
from makefile2dot import makefile2dot


def test_makefile():
    '''
    Should still return the target.
    '''
    with io.StringIO() as output:
        with redirect_stdout(output):
            makefile2dot(direction="TB", output="", view=False, flowchart=False)
        result = output.getvalue()

    assert "digraph {" in result
    assert "\trankdir=TB" in result
    assert '\t"output.png" [shape=rectangle]' in result
    assert '\t".twine_checked" [shape=rectangle]' in result
    assert '\t"output.dot" -> Makefile' in result
    assert '\tdist -> ".twine_checked"' in result
