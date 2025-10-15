#!/usr/bin/env cwl-runner

$graph:
- class: Workflow
  id: extrac-inundation-census-tract
  label: Populations Vulnerable to Dam Failure
  doc: Processor for determining Census tracts that fall within inundation zone of given dam inundation map
  requirements: 
    ScatterFeatureRequirement: {}
  inputs:
    dam_id_array:
      label: Dam identifier
      doc: Takes NID dam ids as input to extract inundation for census tract
      type: string[]
    url:
      label: URL
      doc: URL to the hydroshare dataset
      type: string
  outputs: 
   - id: stac
     type: Directory[]
     outputSource:
     - step_1/output_directory

  steps:
    step_1:
      in:
        dam_id: dam_id_array
        url: url
      run: '#process'
      scatter: dam_id
      scatterMethod: dotproduct
      out: 
       - output_directory

- class: CommandLineTool
  id: process
  requirements:
    DockerRequirement:
      dockerPull: docker.io/geolabs/cybergis-eoap:latest
    InlineJavascriptRequirement: {}
    ResourceRequirement:
      coresMin: 4
      ramMin: 12096
      tmpdirMin: 5000
    EnvVarRequirement:
      envDef:
        AWS_S3_ENDPOINT: "tb20.geolabs.fr:4999"
        AWS_NO_SIGN_REQUEST: "NO"
        AWS_ACCESS_KEY_ID: "minio-admin"
        AWS_SECRET_ACCESS_KEY: "minio-secret-password"
        AWS_HTTPS: "NO"
        AWS_VIRTUAL_HOSTING: "FALSE"
    InitialWorkDirRequirement:
      listing:
      - entryname: run.sh
        entry: |-
          #!/bin/bash
          
          . /opt/conda/etc/profile.d/conda.sh
          conda activate geoedf
          pwd && \
          python /app.py $1 $2 && \
          rm -rf .cache pysal_data .local .config run.sh std.out

  inputs:
    dam_id:
      type: string
      inputBinding:
        position: 2
    url:
      type: string
      inputBinding:
        position: 1

  outputs:
    output_directory:
       type: Directory
       outputBinding:
         glob: .

  stderr: std.out

  baseCommand:
  - /bin/bash
  - run.sh
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 1.0.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf
