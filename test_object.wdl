###########################################################################
#WORKFLOW DEFINITION
###########################################################################
workflow test_object {
  
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
    Array[Array[File]] trio_gvcfs = check_size.trio_gvcfs
  }

}


task check_size {

  Object SampleAttrs

  String sample_id = SampleAttrs.sample_id
  File sample_gvcf = SampleAttrs.sample_gvcf

  String father_id = SampleAttrs.father_rg_id
  File father_gvcf = SampleAttrs.father_gvcf

  String mother_id = SampleAttrs.mother_rg_id
  File mother_gvcf = SampleAttrs.mother_gvcf


    
  Float sample_gvcf_size_gb = size(sample_gvcf, "G")
  Float father_gvcf_size_gb = size(father_gvcf, "G")
  Float mother_gvcf_size_gb = size(mother_gvcf, "G")


  command {

    echo "Sample: ${sample_id}  | Path: ${sample_gvcf} | Filesize: ${sample_gvcf_size_gb}"
    echo "Father: ${father_id}  | Path: ${father_gvcf} | Filesize: ${father_gvcf_size_gb}"
    echo "Mother: ${mother_id}  | Path: ${mother_gvcf} | Filesize: ${mother_gvcf_size_gb}"

  }

  output {
    File response = stdout()
    Array[File] trio_gvcfs = glob("*.vcf.gz")
  }

  runtime {
    docker: "gatksv/sv-base-mini:cbb1fc"
  }
}