FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase:dev_v3.4.1-2xenial0_cv0.2.14

MAINTAINER PhenoMeNal-H2020 Project (phenomenal-h2020-users@googlegroups.com)

LABEL software="rNMR1d"
LABEL software.version="1.2.14"
LABEL version="0.1"
LABEL Description="Rnmr1D replays the macro-command sequence generated within NMRProcFlow."
LABEL website="https://bitbucket.org/nmrprocflow/rnmr1d"
LABEL documentation="https://bitbucket.org/nmrprocflow/rnmr1d"
LABEL license="https://github.com/phnmnl/container-rnmr1d/blob/master/License.txt"
LABEL tags="Metabolomics"

RUN mkdir -p /opt/rnmr1d
WORKDIR /opt/rnmr1d

# Install packages for compilation
RUN apt-get -y update && apt-get -y --no-install-recommends install ca-certificates wget zip unzip git libcurl4-gnutls-dev libcairo2-dev libxt-dev libxml2-dev libv8-dev libnlopt-dev libnlopt0 gdebi-core pandoc pandoc-citeproc software-properties-common make gcc gfortran g++ r-recommended r-cran-rcurl r-cran-foreach r-cran-multicore r-cran-base64enc r-cran-qtl r-cran-xml libgsl2 libgsl0-dev gsl-bin && \
 R -e "install.packages(c('Rcpp','rjson', 'V8'), repos='https://mirrors.ebi.ac.uk/CRAN/')" && \
 R -e "install.packages(c('docopt','doParallel', 'ptw', 'signal', 'openxlsx'), repos='https://mirrors.ebi.ac.uk/CRAN/')" && \
 R -e "source('http://bioconductor.org/biocLite.R'); biocLite('MassSpecWavelet'); biocLite('jsonlite'); biocLite('impute');" && \
 R -e "install.packages(c('gsl','RcppGSL','inline'), repos='https://mirrors.ebi.ac.uk/CRAN/')" && \
 R -e "install.packages('rvest', repos='https://mirrors.ebi.ac.uk/CRAN/')" && \
 R -e "install.packages('speaq', repos='https://mirrors.ebi.ac.uk/CRAN/')" && \
 git clone https://bitbucket.org/nmrprocflow/rnmr1d /usr/src/rnmr1d && \
 cp -rf /usr/src/rnmr1d/src/* /opt/rnmr1d && rm -rf /usr/src/rnmr1d && \
 echo 'library(Rcpp); Rcpp.package.skeleton(name="Rnmr1D", code_files="libspec/Rnmr.R",  cpp_files = "libspec/libCspec.cpp", example_code = FALSE, author="Daniel Jacob", email="djacob65@gmail.com"); ' | /usr/bin/R BATCH --vanilla && \
    cp ./libspec/configure* ./Rnmr1D/ && \
    chmod 755 ./Rnmr1D/configure* && \
    cp ./libspec/Makevars.in ./Rnmr1D/src && \
    echo 'install.packages("Rnmr1D", lib=c("/usr/local/lib/R/site-library/"), repos = NULL, type = "source");' | /usr/bin/R BATCH --vanilla && \ 
    [ -d "./Rnmr1D" ] && rm -rf ./Rnmr1D && \
    apt-get -y --purge --auto-remove remove make gcc gfortran g++ && apt-get -y --purge remove libcurl4-gnutls-dev libcairo2-dev libxt-dev libxml2-dev libv8-dev libnlopt-dev && \
    apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /usr/src/rnmr1d /tmp/* /var/tmp/*

# Add scripts to container
ADD scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Add testing to container
ADD runTest1.sh /usr/local/bin/runTest1.sh
ADD runTest2.sh /usr/local/bin/runTest2.sh

# Define Entry point script
#ENTRYPOINT [ "/opt/rnmr1d/exec/Rnmr1D" ]
#CMD [ "/opt/rnmr1d/exec/Rnmr1D" ]

