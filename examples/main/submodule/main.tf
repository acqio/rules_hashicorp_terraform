variable read_file {
  type = bool
}

data local_file read {
  filename = format("%s/file", path.module)
}

output return {
  value = data.local_file.read.content
}
