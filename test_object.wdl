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
  
  Array[File] trio_gvcfs = SampleAttrs.trio_gvcf_array
  
  Float input_file_size_gb = size(sample_gvcf, "G")

  command {

    echo "Sample: ${sample_id}  | Path: ${sample_gvcf} | Filesize: ${input_file_size_gb}"

    for GVCF in ${trio_gvcfs}
    do
      file_size_kb=`du -k "$GVCF" | cut -f1`
      echo "$GVCF : $file_size_kb"
    done

  }

  output {
    File response = stdout()
  }

  runtime {
    docker: "gatksv/sv-base-mini:cbb1fc"
  }
}