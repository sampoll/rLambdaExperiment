
# TODO: handle python not found
rLambdaInitialize <- function(path='/anaconda/bin/python')  {
  if (!requireNamespace("reticulate"))
    stop("can't attach R package reticulate")
  Sys.setenv('RETICULATE_PYTHON'=path)
  py_discover_config()
  if (!py_module_available("json"))
    stop("python module json is not installed")
  if (!py_module_available("boto3"))
    stop("python module boto3 is not installed")
}

# TODO: handle json input file not found
# TODO: handle lambdafname does not exist

rLambdaExecute <- function(jsonin, lambdafname)  { 
  requireNamespace("reticulate")
  Sys.setenv('RETICULATE_PYTHON'=path)
  jsn <- import("json", convert = FALSE)
  bto <- import("boto3", convert = FALSE)
  builtins <- import_builtins()

  payload = jsn$load(builtins$open(jsonin))
  lambda.client <- bto$client('lambda')
  response <- lambda.client$invoke(FunctionName=lambdafname, 
    InvocationType='RequestResponse', 
    Payload=jsn$dumps(payload))
  dct <- jsn$loads(response[['Payload']]$read()$decode('utf=8'))
  return(dct)
}

# TODO: build JSON input file from parameters
# Note: different lambda functions will require different JSON input

