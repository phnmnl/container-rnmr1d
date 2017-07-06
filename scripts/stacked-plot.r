#!/usr/bin/env Rscript
# Load required libraries
#library(xcms)

# Set options
options(stringAsfactors=FALSE, useFancyQuotes=FALSE)
stack_height <- 0.67
max_ppm_shift <- 1
plot_type <- "simple"

# Read command line arguments
args <- commandArgs(trailingOnly=TRUE)

if (length(args) == 0) stop("No parameters are given!\n")

# Process command line arguments
for (arg in args) {
	command <- strsplit(x=arg, split="=")[[1]][1]
	value <- strsplit(x=arg, split="=")[[1]][2]

	if (command == "data_matrix_file") {
		data_matrix_file <- as.character(value)
		print(paste("Data matrix file is:", data_matrix_file))
	}

	if (command == "pdf_output") {
		pdf_output <- as.character(value)
		print(paste("PDF output set to:", pdf_output))
	}

	if (command == "stack_height") {
		stack_height <- as.numeric(value)
		print(paste("Setting graphical height of stack to:", stack_height))
	}

	if (command == "max_ppm_shift") {
		max_ppm_shift <- as.numeric(value)
		print(paste("Setting maximum ppm shift to:", max_ppm_shift))
	}

	if (command == "plot_type") {
		plot_type <- as.character(value)
		print(paste("Setting plot type to:", plot_type))
	}
}

# Check required command line arguments
if (is.na(data_matrix_file) | is.na(pdf_output)) stop("Please specify at least the command line options data_matrix_file and pdf_output!\n")



# MAIN
# Following code is adapted from Daniel Jacob

matfile <- data_matrix_file

specmat <- read.table(matfile, header=T, sep="\t", stringsAsFactors=FALSE)

ppm <- as.numeric(gsub('_', '.', gsub('B', '', colnames(specmat)[-1])))
ppm_range <- c(min(ppm), max(ppm))

cols <- rainbow(dim(specmat)[1])

# Prepare stacked Plot
Ymax <- max(specmat[,-1])        # intensity limit
ppm_lim <- ppm_range             # c(ppm min, ppm max)
K <- stack_height                # Graphical height of the stack (0 .. 1)
ppm_shift_max <- max_ppm_shift   # Maximum ppm shift

selspec <- seq(from=dim(specmat)[1], to=2, by=-1)

# Actual stacked plot
pdf(pdf_output, encoding="ISOLatin1", pointsize=10, width=5, height=5, family="Helvetica")

plot(cbind(ppm, t(specmat[1,-1])), xlim=rev(ppm_lim), ylim=c(0,Ymax), xlab="ppm", ylab="Intensity", main="NMR FID stacked plot", type="h", col="blue")

if (plot_type=="perspective") {
	for (ind in c(1:length(selspec))) {
		i <- selspec[ind]
		dppm <- ppm_shift_max*(i-1)/dim(specmat)[1]
		y_offset <- (i-1)*K*Ymax/dim(specmat)[1]
		segments(ppm + dppm, y_offset, ppm + dppm, t(specmat[i,-1]) + y_offset, col=cols[(ind-1) %% length(cols) + 1])
	}
} else {
	for (ind in c(1:length(selspec))) {
		i <- selspec[ind]
		segments( ppm, (i-1)*K*Ymax/dim(specmat)[1], ppm, t(specmat[i,-1]) + (i-1)*K*Ymax/dim(specmat)[1], col=cols[(ind-1) %% length(cols) + 1] )
	}
}

dev.off()


