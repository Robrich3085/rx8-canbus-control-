setTickRate&#40;25&#41;

function onTick&#40;&#41;

 RPMreal = getChannel&#40;"RPM"&#41; -- rpm input
 if RPMreal ~= nil then
 RPMscale = &#40;RPMreal&#41;*3.85 -- scale to what RX8 canbus is expecting
 else RPMscale = 0
 end
 RPML = bit.band&#40;RPMscale, 0xFF&#41; -- mask out high byte
 RPMH = bit.rshift&#40;RPMscale, 8&#41; -- shift high byte to the right

 SPEEDreal = getChannel&#40;"LF_Wheelspd"&#41; -- speed input
 if SPEEDreal ~= nil then
 SPEEDscale = 160.06*&#40;SPEEDreal&#41;+10010 -- scale to what RX8 canbus is expecting
 else SPEEDscale = 0
 end
 SPEEDL = bit.band&#40;SPEEDscale, 0xFF&#41; -- mask out high byte
 SPEEDH = bit.rshift&#40;SPEEDscale, 8&#41; -- shift high byte to the right

 data201 = &#123;RPMH,RPML,0,0,SPEEDH,SPEEDL,0,0&#125;
 txCAN&#40;0, 0x201, 0, data201&#41;

 TEMPreal = getChannel&#40;"CLTemp"&#41; -- coolant temperature input
 if TEMPreal ~= nil then
 TEMPscale = &#40;TEMPreal*1.8+32&#41;*0.7 --scale coolant temp
 else TEMPscale = 0
 end

 OILPRESSreal = getChannel&#40;"OilPress"&#41; -- oil pressure input
 if OILPRESSreal ~= nil and OILPRESSreal>15 then -- if logic to control binary oil temp gauge
 OPbit = 1
 else
 OPbit = 0
 end

 BATTreal = getChannel&#40;"Batt"&#41; -- battery voltage input
 if BATTreal ~= nil and BATTreal > 11 then --if logic to control battery light
 BATTbyte = 0
 else
 BATTbyte = 64
 end

 data420 = &#123;TEMPscale,0,0,0,OPbit,0,BATTbyte,0&#125; -- byte 4 is oil pressure, 5 is CEL &#40;64=on&#41;, 6 is battery charge &#40;64=on&#41;
 txCAN&#40;0, 0x420, 0, data420&#41;

 data200 = &#123;0,0,255,255,0,50,6,129&#125; -- needed for EPS to work
 txCAN&#40;0, 0x200, 0, data200&#41;

 data202 = &#123;137,137,137,25,52,31,200,255&#125; -- needed for EPS to work
 txCAN&#40;0, 0x202, 0, data202&#41;

end
