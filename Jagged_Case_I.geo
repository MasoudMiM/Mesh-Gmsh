// Gmsh project created on Wed Oct 26 09:00:10 2016

PipeLength = 5;
NlayersThickness = 76;
NlayersLength = 500;
CrackDepth = 3/6;
R_in = 0.14605;
R_out = 0.1524;
CrackLength = 0.025;
CrackLoc = 1.5; // corner of the crack

//-- horizontal part
l1 = 0.5;
DmgAngle2 = Pi/20;


CrackLengthRatio = CrackLength / PipeLength;
RemainThickness = CrackDepth*(R_out - R_in);
R_outCr = R_in + RemainThickness;
NlayersLengthRemain = ((PipeLength-(CrackLoc+CrackLength))/PipeLength)*NlayersLength;
Printf("Number of elements in before the defect section is %f",NlayersLength);
Printf("Number of elements in after the defect section is %f",NlayersLengthRemain);

IntactCoefMesh = CrackLoc/PipeLength;
DmgAngle = Pi/4; // Should be less than Pi/2 for this code!
DmgCoefMsh = DmgAngle/(Pi/2);
DmgCoefMsh2 = (Pi/2-DmgAngle)/(Pi/2);

//Mesh.CharacteristicLengthFromCurvature = 1;
PointCoefMesh = 0.0012;
//----------------------------------------- Section of the pipe before the defect
Point(1) = {R_in, 0, 0, PointCoefMesh};
Point(2) = {R_out, 0, 0, PointCoefMesh};
Line(1) = {1,2};

surfaceVector_L_1[]=Extrude {0,0,CrackLoc} {
	Line{1}; Layers{IntactCoefMesh*NlayersLength};Recombine;
};

//+
surfaceVector_bd_V1[] = Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle-DmgAngle2} {
  Surface{surfaceVector_L_1[1]}; Layers{( (DmgAngle-DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_bd_V2[] = Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle2} {
  Surface{surfaceVector_bd_V1[0]}; Layers{( DmgAngle2/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_bd_V22[] = Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_bd_V2[0]}; Layers{( (Pi/2-DmgAngle)/(Pi/2) )*NlayersThickness};Recombine;
};


surfaceVector_bd_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V22[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_bd_V4[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V3[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_bd_V5[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V4[0]}; Layers{NlayersThickness};Recombine;
};

//----------------------------------------- Section of the pipe with defect

Point(3000) = {R_in, 0, CrackLoc, PointCoefMesh};
Point(4000) = {R_outCr, 0, CrackLoc, PointCoefMesh};
Line(3000) = {3000,4000};

surfaceVector_L_30[]=Extrude {{0,0,1},{0,0,CrackLoc},DmgAngle-DmgAngle2}{
        Line{3000}; Layers{( (DmgAngle-DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_d_V30[]=Extrude {0,0,CrackLength} {
  Surface{3004}; Layers{CrackLengthRatio*NlayersLength}; Recombine;
};
Point(7000) = {R_in*Cos(DmgAngle-DmgAngle2), R_in*Sin(DmgAngle-DmgAngle2), CrackLoc, PointCoefMesh};
Point(8000) = {R_outCr*Cos(DmgAngle-DmgAngle2), R_outCr*Sin(DmgAngle-DmgAngle2), CrackLoc, PointCoefMesh};
Line(7000) = {7000,8000};

surfaceVector_L_70[]=Extrude {{0,0,1},{0,0,CrackLoc},DmgAngle2}{
        Line{7000}; Layers{( (DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_d_V70[]=Extrude {0,0,CrackLength} {
  Surface{7004}; Layers{CrackLengthRatio*NlayersLength}; Recombine;
};


Point(300) = {R_in*Cos(DmgAngle), R_in*Sin(DmgAngle), CrackLoc, PointCoefMesh};
Point(400) = {R_out*Cos(DmgAngle), R_out*Sin(DmgAngle), CrackLoc, PointCoefMesh};
Line(300) = {300,400};

surfaceVector_L_3[]=Extrude {0,0,CrackLength}{
        Line{300}; Layers{CrackLengthRatio*NlayersLength};Recombine;
};

surfaceVector_d_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_L_3[1]}; Layers{DmgCoefMsh2*NlayersThickness};Recombine;
};

surfaceVector_d_V4[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V3[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V5[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V4[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V6[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V5[0]}; Layers{NlayersThickness};Recombine;
};


//----------------------------------------- Horizontal Part

Point(30000) = {R_in*Cos(DmgAngle-DmgAngle2), R_in*Sin(DmgAngle-DmgAngle2), CrackLoc+CrackLength, PointCoefMesh};
Point(40000) = {R_outCr*Cos(DmgAngle-DmgAngle2), R_outCr*Sin(DmgAngle-DmgAngle2), CrackLoc+CrackLength, PointCoefMesh};
Line(30000) = {30000,40000};

surfaceVector_L_300[]=Extrude {{0,0,1},{0,0,CrackLoc+CrackLength},DmgAngle2}{
        Line{30000}; Layers{(DmgAngle2/(Pi/2))*NlayersThickness};Recombine;
};

surfaceVector_d_V300[]=Extrude {0,0,l1} {
  Surface{30004}; Layers{(l1/PipeLength)*NlayersLength}; Recombine;
};

Point(300000) = {R_in*Cos(DmgAngle), R_in*Sin(DmgAngle), CrackLoc+CrackLength, PointCoefMesh};
Point(400000) = {R_out*Cos(DmgAngle), R_out*Sin(DmgAngle), CrackLoc+CrackLength, PointCoefMesh};
Line(300000) = {300000,400000};

surfaceVector_L_30[]=Extrude {0,0,l1}{
        Line{300000}; Layers{(l1/PipeLength)*NlayersLength};Recombine;
};

surfaceVector_d_V30[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_L_30[1]}; Layers{DmgCoefMsh2*NlayersThickness};Recombine;
};

surfaceVector_d_V40[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V30[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V50[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V40[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V60[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V50[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V70[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle-DmgAngle2} {
  Surface{surfaceVector_d_V60[0]}; Layers{ (Pi/2-DmgAngle-DmgAngle2)/(Pi/2) *NlayersThickness};Recombine;
};

Point(700000) = {R_in*Cos(Pi/2-DmgAngle2-DmgAngle), R_in*Sin(Pi/2-DmgAngle2-DmgAngle), CrackLoc+CrackLength, PointCoefMesh};
Point(800000) = {R_outCr*Cos(Pi/2-DmgAngle2-DmgAngle), R_outCr*Sin(Pi/2-DmgAngle2-DmgAngle), CrackLoc+CrackLength, PointCoefMesh};
Line(700000) = {700000,800000};

surfaceVector_L_3000[]=Extrude {0,0,l1}{
        Line{700000}; Layers{(l1/PipeLength)*NlayersLength};Recombine;
};

surfaceVector_d_V3000[]=Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle2} {
  Surface{surfaceVector_L_3000[1]}; Layers{( DmgAngle2/(Pi/2) )*NlayersThickness};Recombine;
};


//----------------------------------------- Horizontal (End)

//----------------------------------------- Rest of the pipe
Point(50000) = {R_in, 0, CrackLoc+CrackLength+l1, PointCoefMesh};
Point(60000) = {R_out, 0, CrackLoc+CrackLength+l1, PointCoefMesh};
Line(50000) = {50000,60000};

surfaceVector_L_10[]=Extrude {0,0,PipeLength-(CrackLoc+CrackLength+l1)} {
	Line{50000}; Layers{( (PipeLength-(CrackLoc+CrackLength+l1))/(PipeLength) )*NlayersLength};Recombine;
};

//+
surfaceVector_bd_V10000[] = Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle-DmgAngle2} {
  Surface{surfaceVector_L_10[1]}; Layers{( (DmgAngle-DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_bd_V20000[] = Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle2} {
  Surface{surfaceVector_bd_V10000[0]}; Layers{( DmgAngle2/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_bd_V220000[] = Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_bd_V20000[0]}; Layers{( (Pi/2-DmgAngle)/(Pi/2) )*NlayersThickness};Recombine;
};


surfaceVector_bd_V30000[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V220000[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_bd_V40000[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V30000[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_bd_V50000[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V40000[0]}; Layers{NlayersThickness};Recombine;
};


//----------------------------------------- Creating Physical Volumes and Surfaces
//Physical Surface("Side1") = {surfaceVector_bd_V1[2], surfaceVector_bd_V2[2], surfaceVector_bd_V3[2], surfaceVector_bd_V4[2]};
//Physical Surface("Side2") = {surfaceVector_ad_V1[4], surfaceVector_ad_V2[4], surfaceVector_ad_V3[4], surfaceVector_ad_V4[4]};

//Physical Surface("Outer") = {surfaceVector_bd_V1[3],surfaceVector_bd_V2[3],surfaceVector_bd_V3[3],surfaceVector_bd_V4[3],
//surfaceVector_d_V1[3],surfaceVector_d_V2[3],surfaceVector_d_V3[3],surfaceVector_d_V4[3],surfaceVector_d_V5[3],
//surfaceVector_ad_V1[3],surfaceVector_ad_V2[3],surfaceVector_ad_V3[3],surfaceVector_ad_V4[3]};

//Physical Surface("Inner") = {surfaceVector_bd_V1[5], surfaceVector_bd_V2[5], surfaceVector_bd_V3[5], surfaceVector_bd_V4[5],
//surfaceVector_d_V1[5], surfaceVector_d_V2[5], surfaceVector_d_V3[5], surfaceVector_d_V4[5], surfaceVector_d_V5[5],
//surfaceVector_ad_V1[5],surfaceVector_ad_V2[5],surfaceVector_ad_V3[5],surfaceVector_ad_V4[5]};
 
//Physical Volume("Body") = {3, 2, 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};

Mesh.Algorithm = 6; // "Frontal" approach
Mesh.Algorithm3D = 1; // "Delauncy" approach
Mesh.SaveAll = 1;


/* surfaceVector contains in the following order:
    [0]	- front surface (opposed to source surface)
    [1] - extruded volume
    [2] - bottom surface
    [3] - right surface
    [4] - top surface
    [5] - left surface */


