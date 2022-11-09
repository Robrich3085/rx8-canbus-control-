setTickRate&#40;25&#41;

function onTick&#40;&#41;

 RPMreal = 1000 -- rpm input
 RPMscale = &#40;RPMreal&#41;*3.85 -- scale to what RX8 canbus is expecting
 RPML = bit.band&#40;RPMscale, 0xFF&#41; -- mask out high byte
 RPMH = bit.rshift&#40;RPMscale, 8&#41; -- shift high byte to the right

 SPEEDreal = 20 -- speed input
 SPEEDscale = 160.06*&#40;SPEEDreal&#41;+10010 -- scale to what RX8 canbus is expecting
 SPEEDL = bit.band&#40;SPEEDscale, 0xFF&#41; -- mask out high byte
 SPEEDH = bit.rshift&#40;SPEEDscale, 8&#41; -- shift high byte to the right

 data201 = &#123;RPMH,RPML,0,0,SPEEDH,SPEEDL,0,0&#125;
 txCAN&#40;0, 0x201, 0, data201&#41;

 TEMPreal = 190 -- coolant temperature input
 TEMPscale = TEMPreal*0.7 --scale coolant temp

 OILPRESSreal = 25 -- oil pressure input
 if OILPRESSreal>15 then -- if logic to control binary oil temp gauge
 OPbit = 1
 else
 OPbit = 0
 end

 data420 = &#123;TEMPscale,0,0,0,OPbit,0,0,0&#125; -- byte 4 is oil pressure, 5 is CEL &#40;64=on&#41;, 6 is battery charge &#40;64=on&#41;
 txCAN&#40;0, 0x420, 0, data420&#41;

 data200 = &#123;0,0,255,255,0,50,6,129&#125; -- needed for EPS to work
 txCAN&#40;0, 0x200, 0, data200&#41;

 data202 = &#123;137,137,137,25,52,31,200,255&#125; -- needed for EPS to work
 txCAN&#40;0, 0x202, 0, data202&#41;

end
