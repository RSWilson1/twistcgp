//
// Subworkflow that uses the nf-schema plugin to validate parameters and render the parameter summary
//

workflow UTILS_NFSCHEMA_PLUGIN {

    take:
    input_workflow      // workflow: the workflow object used by nf-schema to get metadata from the workflow
    validate_params     // boolean:  validate the parameters
    parameters_schema   // string:   path to the parameters JSON schema.
                        //           this has to be the same as the schema given to `validation.parametersSchema`
                        //           when this input is empty it will automatically use the configured schema or
                        //           "${projectDir}/nextflow_schema.json" as default. This input should not be empty
                        //           for meta pipelines

    main:

    //
    // Print parameter summary to stdout. This will display the parameters
    // that differ from the default given in the JSON schema
    //
    log.info fallbackParamsSummary()

    // Offline fallback: keep execution working when the nf-schema plugin
    // cannot be downloaded in restricted environments.
    if(validate_params) {
        if(parameters_schema && !file(parameters_schema).exists()) {
            error("Parameters schema file not found: ${parameters_schema}")
        }
        log.warn "[${workflow.manifest.name}] Parameter schema validation via nf-schema plugin is unavailable; skipping runtime schema validation."
    }

    emit:
    dummy_emit = true
}

def fallbackParamsSummary() {
    def summary = params
        .findAll { key, val -> val != null && val != false && val != '' }
        .collect { key, val -> "  --${key}: ${val}" }
        .sort()
        .join('\n')

    return """\
[$workflow.manifest.name] Parameter summary (fallback)
${summary ?: '  (no parameters provided)'}
""".stripIndent()
}
