add_triton_library(TPtrIR
  TPtrDialect.cpp

  DEPENDS
  TPtrTableGen

  LINK_LIBS PUBLIC
  TritonIR
  MLIRIR
  MLIRPtrDialect
  )
