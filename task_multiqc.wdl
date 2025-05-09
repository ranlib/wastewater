version 1.0

task task_multiqc {
  input {
    Array[File] inputFiles
    String outputPrefix
    String docker = "multiqc/multiqc:v1.28"
    String memory = "8GB"
  }
  
  command <<<
    set -ex
    for file in ~{sep=' ' inputFiles}; do
    if [ -e $file ] ; then
    cp $file .
    else
    echo "<W> multiqc: $file does not exist!"
    fi
    done
    multiqc --force --no-data-dir -n ~{outputPrefix}.multiqc .
  >>>

  output {
    File report = "${outputPrefix}.multiqc.html"
  }

  runtime {
    docker: docker
    memory: memory
  }
}

