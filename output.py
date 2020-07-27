import madgraph.iolibs.export_v4 as export_v4
class My_ggHg_Exporter(export_v4.ProcessExporterFortranSA):
    matrix_template = "Templates/matrix_standalone_v4_mod_hel_sum.inc"

