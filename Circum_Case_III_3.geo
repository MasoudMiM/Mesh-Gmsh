// Gmsh project created on Wed Oct 26 09:00:10 2016

PipeLength = 5;
NlayersThickness = 76;
NlayersLength = 500;

CrackDepth = 3/6;
DmgAngle = Pi/4; // Should be less than Pi/2 for this code!
CrackLength = 0.4;

CrackLoc = 1.5; // corner of the crack

R_in = 0.14605;
R_out = 0.1524;

CrackLengthRatio = CrackLength / PipeLength;
RemainThickness = CrackDepth*(R_out - R_in);
R_outCr = R_in + RemainThickness;
NlayersLengthRemain = ((PipeLength-(CrackLoc+CrackLength))/PipeLength)*NlayersLength;
Printf("Number of elements in before the defect section is %f",NlayersLength);
Printf("Number of elements in after the defect section is %f",NlayersLengthRemain);

IntactCoefMesh = CrackLoc/PipeLength;
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
surfaceVector_bd_V1[] = Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle} {
  Surface{surfaceVector_L_1[1]}; Layers{DmgCoefMsh*NlayersThickness};Recombine;
};

surfaceVector_bd_V2[] = Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_bd_V1[0]}; Layers{DmgCoefMsh2*NlayersThickness};Recombine;
};


surfaceVector_bd_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_bd_V2[0]}; Layers{NlayersThickness};Recombine;
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

surfaceVector_L_30[]=Extrude {{0,0,1},{0,0,CrackLoc},DmgAngle}{
        Line{3000}; Layers{DmgCoefMsh*NlayersThickness};Recombine;
};

surfaceVector_d_V30[]=Extrude {0,0,CrackLength} {
  Surface{3004}; Layers{CrackLengthRatio*NlayersLength}; Recombine;
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


//----------------------------------------- Rest of the pipe
Point(500) = {R_in, 0, CrackLoc+CrackLength, PointCoefMesh};
Point(600) = {R_out, 0, CrackLoc+CrackLength, PointCoefMesh};
Line(500) = {500,600};

surfaceVector_L_4[]=Extrude {0,0,PipeLength-(CrackLoc+CrackLength)} {
        Line{500}; Layers{NlayersLengthRemain};Recombine;
};

surfaceVector_ad_V1[]=Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle} {
  Surface{surfaceVector_L_4[1]}; Layers{DmgCoefMsh*NlayersThickness};Recombine;
};

surfaceVector_ad_V2[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_ad_V1[0]}; Layers{DmgCoefMsh2*NlayersThickness};Recombine;
};

surfaceVector_ad_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_ad_V2[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_ad_V4[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_ad_V3[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_ad_V5[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_ad_V4[0]}; Layers{NlayersThickness};Recombine;
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


