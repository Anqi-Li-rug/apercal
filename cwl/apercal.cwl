cwlVersion: v1.0
class: Workflow

inputs:
  target: Directory
  fluxcal: Directory
  polcal: Directory

outputs:
  calibrated:
    type: Directory
    outputSource: ccal/target_calibrated

steps:
  preflag:
    run: steps/preflag.cwl
    in:
      target: target
      fluxcal: fluxcal
      polcal: polcal
    out:
      - target_preflagged
      - fluxcal_preflagged
      - polcal_preflagged

  ccal:
    run: steps/ccal.cwl
    in:
      target_preflagged: preflag/target_preflagged
      fluxcal_preflagged: preflag/fluxcal_preflagged
      polcal_preflagged: preflag/polcal_preflagged
    out:
      - target_calibrated
      - polcal_calibrated
      - fluxcal_calibrated
      - target_Df
      - target_Kcross
      #- target_Xf
      - target_Bscan
      - target_G0ph
      - target_G1ap
      - target_K

  convert:
    run: steps/convert.cwl
    in:
      target_calibrated: ccal/target_calibrated
      fluxcal_calibrated: ccal/fluxcal_calibrated
      polcal_calibrated: ccal/polcal_calibrated
    out:
      - target_mir
      - fluxcal_mir
      - polcal_mir

  scal:
    run: steps/scal.cwl
    in:
      target_mir: convert/target_converted
      fluxcal_mir: convert/fluxcal_converted
      polcal_mir: covert/polcal_converted
    out:
      - target_selfcalibrated


# next steps:
#continuum
#line
#polarisation
#mosaic
#transfer
