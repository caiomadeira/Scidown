@echo off
#Path to cmft program, can be downloaded here: https://github.com/dariomanesku/cmft
SET cmft="cmft.exe"

#The name of the skybox. The input file should be named %name%.hdr. Output will be named %name%.dds
SET name="sky"

:: Typical parameters for radiance filter.
%cmft% %* --input "%name%.hdr"              ^
          ::Filter options                  ^
          --filter radiance                 ^
          --srcFaceSize 256                 ^
          --excludeBase true                ^
          --mipCount 20                     ^
          --glossScale 12                   ^
          --glossBias 3                     ^
          --lightingModel blinnbrdf         ^
          --edgeFixup none                  ^
          --dstFaceSize 256                 ^
          ::Processing devices              ^
          --numCpuProcessingThreads 4       ^
          --useOpenCL false                 ^
          --clVendor anyGpuVendor           ^
          --deviceType gpu                  ^
          --deviceIndex 0                   ^
          ::Aditional operations            ^
          --inputGammaNumerator 1.0         ^
          --inputGammaDenominator 1.0       ^
          --outputGammaNumerator 1.0        ^
          --outputGammaDenominator 1.0      ^
          --generateMipChain false          ^
          ::Output                          ^
          --outputNum 1                     ^
          --output0 "%name%"                ^
		  --output0params dds,rgba32f,cubemap
