# WeightedEdgeListFormat
A small package that I needed for multiple Pluto.jl projects and wanted to access easily.

It loads certain files into weighted graphs

Doesn't support:

  * Loading multiple graphs from the same file

  * Assigning names to graphs


# Changelog

## v. 0.3.0

Fixes major error with regards of reading wrong weights if the node labeling starts with 0

Adds new options to load graphs. (Directed/Undirected; Labels/Indices)

Adds some tests

## v. 0.2.0

Adds support for writing graphs.

Changes from CSV.jl to DelimitedFiles.jl

