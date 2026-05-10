using Test
using WeightedEdgeListFormat
using SimpleWeightedGraphs
using Graphs

@testset "read_edge_list_weighted not labels" begin

    @testset "basic weighted graph 1 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/spaces_1_index.dat", WELFormat(' '))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    @testset "basic weighted graph 0 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/spaces_0_index.dat", WELFormat(' '))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    @testset "basic weighted graph 0 indexed CSV " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/commas_0_index.csv", WELFormat(','))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    # directed
    @testset "basic weighted graph 1 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/spaces_1_index.dat", WELFormat(' ', true, false, false))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        # Weights in SimpleWeightedDiGraph are in the format (dst, src) for some reason
        @test g.weights[1, 2] == 0
        @test g.weights[2, 3] == 0
        @test g.weights[3, 1] == 0
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[1, 3] == 3
    end

    @testset "basic weighted graph 0 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/spaces_0_index.dat", WELFormat(' ', true, false, false))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        # Weights in SimpleWeightedDiGraph are in the format (dst, src) for some reason
        @test g.weights[1, 2] == 0
        @test g.weights[2, 3] == 0
        @test g.weights[3, 1] == 0
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[1, 3] == 3
    end

    @testset "basic weighted graph 0 indexed CSV " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/commas_0_index.csv", WELFormat(',', true, false, false))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        # Weights in SimpleWeightedDiGraph are in the format (dst, src) for some reason
        @test g.weights[1, 2] == 0
        @test g.weights[2, 3] == 0
        @test g.weights[3, 1] == 0
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[1, 3] == 3
    end

    @testset "not interconnected graph 1 indexed spaces " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/not_interconnected.dat", WELFormat(' '))

        @test nv(g) == 5
        @test ne(g) == 2

        @test labels == [1, 2, 3, 4, 5]


        @test g.weights[1, 2] == 10
        @test g.weights[1, 5] == 10
    end

    @testset "basic weighted graph 0 indexed CSV with header " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_not_labels("./test_graphs/commas_0_index_header.csv", WELFormat(',', false, true, false))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == [1, 2, 3]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end
end

@testset "read_edge_list_weighted labels" begin

    @testset "basic weighted graph 1 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/spaces_1_index.dat", WELFormat(' ', false, false, true))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == ["1", "2", "3"]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    @testset "basic weighted graph 0 indexed" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/spaces_0_index.dat", WELFormat(' ', false, false, true))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == ["0", "1", "2"]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    @testset "basic weighted graph 0 indexed CSV " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/commas_0_index.csv", WELFormat(',', false, false, true))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == ["0", "1", "2"]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end

    @testset "basic weighted graph labels spaces " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/spaces_names.dat", WELFormat(' ', false, false, true))

        @test nv(g) == 5
        @test ne(g) == 6

        @test labels == ["Berlin", "London", "Paris", "Stockholm", "Vienna"]

        @test g.weights[1, 2] == 2
        @test g.weights[1, 5] == 3
        @test g.weights[1, 3] == 1
        @test g.weights[1, 4] == 5
        @test g.weights[2, 3] == 9
        @test g.weights[2, 4] == 11
        @test g.weights[2, 1] == 2
        @test g.weights[5, 1] == 3
        @test g.weights[3, 1] == 1
        @test g.weights[4, 1] == 5
        @test g.weights[3, 2] == 9
        @test g.weights[4, 2] == 11
    end

    @testset "not interconnected graph with labels should be interconnected" begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/not_interconnected.dat", WELFormat(' ', false, false, true))

        @test nv(g) == 3
        @test ne(g) == 2

        @test labels == ["1", "2", "5"]


        @test g.weights[1, 2] == 10
        @test g.weights[1, 3] == 10
    end

    @testset "basic weighted graph 0 indexed CSV with header " begin
        g, labels = WeightedEdgeListFormat.read_edge_list_weighted_labels("./test_graphs/commas_0_index_header.csv", WELFormat(',', false, true, true))

        @test nv(g) == 3
        @test ne(g) == 3

        @test labels == ["0", "1", "2"]

        @test g.weights[1, 2] == 1
        @test g.weights[2, 3] == 2
        @test g.weights[1, 3] == 3
        @test g.weights[2, 1] == 1
        @test g.weights[3, 2] == 2
        @test g.weights[3, 1] == 3
    end
end