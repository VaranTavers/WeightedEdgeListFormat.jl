module WeightedEdgeListFormat
using Graphs
using DataFrames
using GraphIO
using SimpleWeightedGraphs
using DelimitedFiles

export WELFormat
export loadgraph
export loadgraphs
export savegraph
export read_edge_list_weighted

import Graphs: AbstractGraphFormat, loadgraph, loadgraphs, savegraph

struct WELFormat <: AbstractGraphFormat
    delim::AbstractChar
    directed::Bool
    header::Bool
    labels::Bool

    WELFormat() = new(',', false, false, false)
    WELFormat(delim) = new(delim, false, false, false)
    WELFormat(delim, header) = new(delim, header, false, false)
    WELFormat(delim, header, directed) = new(delim, header, directed, false)
    WELFormat(delim, header, directed, labels) = new(delim, header, directed, labels)
end

function loadgraph(io::IO, gname::String, f::WELFormat)
    if f.labels
        g, _ = read_edge_list_weighted_labels(io, f)

        return g
    end

    g, _ = read_edge_list_weighted_not_labels(io, f)

    g
end

loadgraphs(io::IO, f::WELFormat) = loadgraph(io, "...", f)


# ChatGPT clocked in to the problem that I failed to see beforehand (I found it too before asking, however I'm suprised how fast did it find it)
function read_edge_list_weighted_not_labels(filename, format::WELFormat=WELFormat(' '))
    csv = []

    if format.header
        csv, _ = readdlm(filename, format.delim, Float64, '\n'; header=format.header)
    else
        csv = readdlm(filename, format.delim, Float64, '\n')
    end

    if minimum(csv[:, 1]) == 0 || minimum(csv[:, 2]) == 0
        csv[:, 1:2] .+= 1
    end

    # ChatGPT also made it prettier
    src = Int.(csv[:, 1])
    dst = Int.(csv[:, 2])
    w = csv[:, 3]

    labels = collect(1:max(maximum(src), maximum(dst)))

    if !format.directed
        return SimpleWeightedGraph(src, dst, w; combine=max), labels
    end

    SimpleWeightedDiGraph(src, dst, w; combine=max), labels
end

function read_edge_list_weighted_labels(filename, format::WELFormat=WELFormat(' '))
    src_str = []
    dst_str = []
    weights_str = []

    open(filename) do f
        first = true
        while !eof(f)
            s = readline(f)
            if !first || !format.header
                parts = split(s, format.delim)
                if length(parts) == 3
                    push!(src_str, parts[1])
                    push!(dst_str, parts[2])
                    push!(weights_str, parts[3])
                end
            else
                first = false
            end
        end
    end

    all_labels_str = unique(sort(vcat(src_str, dst_str)))
    labels_to_indices = Dict()

    for (i, l) in enumerate(all_labels_str)
        labels_to_indices[l] = i
    end

    # ChatGPT also made it prettier
    src = [labels_to_indices[x] for x in src_str]
    dst = [labels_to_indices[x] for x in dst_str]

    w = [parse(Float64, x) for x in weights_str]

    if !format.directed
        return SimpleWeightedGraph(src, dst, w; combine=max), all_labels_str
    end

    SimpleWeightedDiGraph(src, dst, w; combine=max), all_labels_str
end

function savegraph(io::IO, g::AbstractGraph, gname::String, format::WELFormat)
    writedlm(
        io,
        ([Int(src(e)), Int(dst(e)), e.weight] for e in Graphs.edges(g)),
        format.delim,
    )
end

end # module WeightedEdgeListFormat
