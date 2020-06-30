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
    Array[File] samp_gvcf = check_size.out_sample_gvcf
    Array[File] fa_gvcf = check_size.out_father_gvcf
    Array[File] mo_gvcf = check_size.out_mother_gvcf
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

    gunzip -c ${sample_gvcf} > ./sample.g.vcf
    gunzip -c ${father_gvcf} > ./father.g.vcf
    gunzip -c ${mother_gvcf} > ./mother.g.vcf

  }

  output {
    File response = stdout()
    File out_sample_gvcf = "sample.g.vcf"
    File out_father_gvcf = "father.g.vcf"
    File out_mother_gvcf = "mother.g.vcf"
  }

  runtime {
    docker: "gatksv/sv-base-mini:cbb1fc"
  }
}