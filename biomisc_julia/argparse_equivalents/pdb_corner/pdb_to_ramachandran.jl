# julia
using ArgParse
using BioStructures
using Plots
using Measures
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "creates a ramachandran plot by selecting the model of a pdb file")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb file"
        "--model"
            help = "model to select in the pdb file(default=1)"
            arg_type = Int
            default = 1
            required = false
       	"--pdf"
            help = "output pdf file"   
    end
    return parse_args(s)
end
# main
function main()
    parsed_args = parse_commandline()
    println(parsed_args)
	struc = read(parsed_args["pdb"], PDB)
	phi_angles, psi_angles = ramachandranangles(struc[parsed_args["model"]], standardselector)
	Plots.backend()
	Plots.gr()
	gr(bg= "#4c4c4c")
	scatter(rad2deg.(phi_angles),
	     rad2deg.(psi_angles),
	     label= "",
	     markercolor = "#FFFF00",
	     markerstrokecolor = "#FFFF00",
	     markershape = :star4,
	     markersize = 2,
	     xticks=[-180,-90,0,90,180],
	     yticks=[-180,-90,0,90,180],
	     xlims=(-180,180),
	     ylims=(-180,180),
	     xlabel="Phi",
	     ylabel="Psi",
	     left_margin=10mm,
	     bottom_margin=10mm,
	     right_margin=10mm,
	     top_margin=10mm)
	savefig(parsed_args["pdf"])
end

main()
