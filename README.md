![Logo](figs/logo.png)

# Rnmr1d
Version 1.2.14

## Short description
Rnmr1D replays the macro-command sequence generated within NMRProcFlow 

## Description

Rnmr1D is the main module in the NMRProcFlow web application (http://nmrprocflow.org) concerning the NMR spectra processing. Inside NMRProcFlow, Rnmr1D allows users to process their NMR spectra within a GUI application and thus the macro-command sequence coming from this process can be saved. Outside NMRProcFlow Rnmr1D become a CLI application allowing users to replay the macro-command sequence generated within NMRProcFlow. Moreover, without using NMRProcFlow, this module can also be used to replace any 'home-made script' by a macro-command sequence.

## Key Features

- NMR 1D data processing

## Functionality

- Preprocessing of raw data

## Approaches

## Instrument Data Type

- NMR 1D

## Tool Authors

- [Daniel Jacob](https://www.linkedin.com/in/daniel-jacob-b3bb4855/?ppe=1) (INRA)

## Container Contributors

- [Kristian Peters](https://github.com/korseby) (IPB-Halle)
- [Christoph Ruttkies](https://github.com/c-ruttkies) (IPB-Halle)
- [Pablo Moreno](https://github.com/pcm32) (EMBL-EBI)

## Website

- https://bitbucket.org/nmrprocflow/rnmr1d

## Git Repository

- https://bitbucket.org/nmrprocflow/rnmr1d

## Installation

Rnmr1D is present on all PhenoMeNal Galaxy instances on deployed Cloud Research Environments, under the NMR category in the tool bar to the left of the screen. No installation is needed hence on PhenoMeNal Cloud Research Environments.

For advanced Docker usage:

- Go to the directory where the dockerfile is.
- Create container from dockerfile:

```
docker build -t rnmr1d .
```

Alternatively, pull from repo:

```
docker pull container-registry.phenomenal-h2020.eu/phnmnl/rnmr1d
```

## Usage Instructions

On a PhenoMeNal Cloud Research Environment, go to NMR tool category, and then click on rnmr1d, and fill the expected input files, then press Run. 

Alternatively, to use locally through the docker image:

```
docker run --entrypoint=/opt/rnmr1d/exec/Rnmr1D container-registry.phenomenal-h2020.eu/phnmnl/rnmr1d --help
```

