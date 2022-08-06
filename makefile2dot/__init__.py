"""
Define the needed functions.
"""

import subprocess as sp
import graphviz as gv


def stream_database():
    """
    Generate and yield entries from the Makefile database.

    This function reads a Makefile using the make program (only tested with GNU
    Make) on your machine. It in turn generates the database constructed from
    the Makefile, ignoring default targets ("-r").
    """
    command = ["make", "-prnB"]
    with sp.Popen(command, stdout=sp.PIPE, universal_newlines=True) as proc:
        for line in proc.stdout:
            if line[0] == '#':
                continue
            if line.isspace():
                continue
            if ': ' not in line:
                continue
            if line[0] == '&':
                continue
            yield line.strip()


def build_graph(stream, **kwargs):
    """
    Build a dependency graph from the Makefile database.
    """
    flowchart = kwargs.get('flowchart', False)
    direction = kwargs.get('direction', 'TB')
    graph = gv.Digraph(comment="Makefile")
    graph.attr(rankdir=direction)
    for line in stream:
        target, dependencies = line.split(':')

        # Draw all targets except .PHONY (it isn't really a target).
        if target != ".PHONY":
            graph.node(target)

        for dependency in dependencies.strip().split(' '):
            if dependency in ["default", "clean"]:
                continue
            elif target == ".PHONY":
                graph.node(dependency, shape="circle")
            elif target in ["default"]:
                graph.node(dependency, shape="rectangle")
            else:
                graph.node(dependency, shape="rectangle")
                if flowchart:
                    graph.edge(dependency, target)
                else:
                    graph.edge(target, dependency)

    return graph


def makefile2dot(**kwargs):
    """
    Visualize a Makefile as a Graphviz graph.
    """

    direction = kwargs.get('direction', "BT")
    if direction not in ["LR", "RL", "BT", "TB"]:
        raise ValueError('direction must be one of "BT", "TB", "LR", RL"')

    output = kwargs.get('output', '')
    view = kwargs.get('view', False)

    graph = build_graph(stream_database(), **kwargs)
    if output == "":
        if view:
            graph.view()
        else:
            print(graph)
    else:
        with open(output, 'w') as file:
            file.write(str(graph))
        if view:
            graph.view()
