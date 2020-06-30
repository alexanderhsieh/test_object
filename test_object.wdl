###########################################################################
#WORKFLOW DEFINITION
###########################################################################
workflow gvcf_to_denovo {
  
  File Table
  Array[Object] SampleTable = read_objects(Table)

  String sample_id

  scatter (line in SampleTable) {
    call check_size {
      input:
      id_to_query=sample_id,
      SampleAttrs=line

    }
  }
  output {
    Array[File] output = check_size.response
  }

}


task check_size {
  String id_to_query

  Object SampleAttrs
  String sample_id = SampleAttrs.sample_id
  File sample_gvcf = SampleAttrs.gvcf_path
  Array[File] trio_gvcfs = SampleAttrs.trio_gvcf_array
  Array[File] trio_gvcf_indexes = SampleAttrs.trio_gvcf_index_array
  Array[String] trio_readgroup_ids = SampleAttrs.trio_readgroup_ids

  Float input_file_size_gb = size(sample_gvcf, "G")
  Array[Float] trio_file_sizes_gb = size(select_all(trio_gvcfs), 'G')

  command {

    if [ "${sample_id}" == "${id_to_query}"]; then
      echo "Sample: ${sample_id}  | Path: ${sample_gvcf} | Filesize: ${input_file_size_gb} Trio_GVCFs: ${trio_gvcfs} | Trio Filesizes: ${trio_file_sizes_gb} "
      exit 1;

  }

  output {
    File response = stdout()
  }

  runtime {
    docker: "gatksv/sv-base-mini:cbb1fc"
  }
}