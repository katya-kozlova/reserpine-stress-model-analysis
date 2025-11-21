log.info ""
log.info " Q U A L I T Y   C O N T R O L "
log.info "==============================="
log.info "Sample number : ${params.Sample}"
log.info "Results location : ${params.results_dir}"

process DownloadFiles {
  output:
    path "reads/*"

  script:
    '''
    mkdir -p reads
    gdown "1kjJFgTtVmd6h6Xkt4Yi8iP3mBQCwSF_T" -O reads/
    gdown "1d-QAPoHslKsxvCYXW6G0hRZVsZ_yin1L" -O reads/
    '''
}

process QC {
  input:
    path reads

  output:
    path "qc"
  
  script:
    '''
    mkdir -p qc
    fastqc -o qc f fastq $reads
    '''
}

process MultiQC{
  publishDir "${params.results_dir}"

  input:
    path fasqcreports

  output:
    path "multiqc_report.html"

  script:
    mutiqc ${fasqcreports}
}

workflow {
  QC(DownloadFiles())
  MultiQC(QC.out)
}