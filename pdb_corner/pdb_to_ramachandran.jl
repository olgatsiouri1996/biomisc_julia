# julia
using ArgParse
using BioStructures
using Plots
using Measures
# input parameters function
function parse_commandline()

    s = ArgParseSettings(description = "creates a ramachandran plot by selecting the model of a pdb file and saves it in a pdf file with the pdb filename")
    @add_arg_table s begin
        "--pdb"
            help = "input pdb filename or pdb id from PDB"
            required = true
        "--model"
            help = "model to select in the pdb file"
            arg_type = Int
            default = 1
            required = false
       	"--mode"
            help = "select either to inport a pdb file from the directory or to download from PDB. default is to download from PDB"
            arg_type = Int
            default = 1
            required = false 
    end
    return parse_args(s)
end
# main
function main()
    parsed_args = parse_commandline()
    println(parsed_args)
# select program

	if parsed_args["mode"]==1
		downloadpdb(parsed_args["pdb"]) do fp
        struc = read(fp, PDB)
    end
	else
		struc = read(join([parsed_args["pdb"],".pdb"],""), PDB)
	end
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
	savefig(join([parsed_args["pdb"],".pdf"],""))
end

main()
