###########################################################################
#WORKFLOW DEFINITION
###########################################################################
workflow gvcf_to_denovo {
  
  File Table
  Array[Object] SampleTable = read_objects(Table)

  scatter (line in SampleTable) {
    call check_size {
      input:
      SampleAttrs=line
    }
  }
  output {
    Array[File] output = check_size.response
  }

}


task check_size {
  Object SampleAttrs
  String sample_id = SampleAttrs.sample_id
  File sample_gvcf = SampleAttrs.gvcf_path
  Float input_file_size_gb = size(sample_gvcf, "G")

  command {
    echo "Sample: ${sample_id}  | Path: ${sample_gvcf} | Filesize: ${input_file_size_gb}"
  }

  output {
    File response = stdout()
  }

  runtime {
    docker: "gatksv/sv-base-mini:cbb1fc"
  }
}