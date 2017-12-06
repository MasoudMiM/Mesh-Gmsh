// Gmsh project created on Wed Oct 26 09:00:10 2016

PipeLength = 5;
NlayersThickness = 76;
NlayersLength = 500;

CrackDepth = 3/6;
CrackLength = 0.1;
NumberOfLengthElm = 100;// (CrackLength/PipeLength)*NlayersLength; or 200  (Number of elements for the carck section)
DmgAngle = Pi/4; // Should be less than Pi/2 for this code!
np = 6; // number of elements for crack's width

R_in = 0.14605;
R_out = 0.1524;
CrackLoc = 1.5; // corner of the crack


DmgCoefMsh = DmgAngle/(Pi/2);
Printf("Damage Mesh Coefficient number (in circumference) is %f",DmgCoefMsh);
DmgCoefMsh2 = (Pi/2-DmgAngle)/(Pi/2);
Printf("Element size (in length) is %f", PipeLength/NlayersLength);
ZGap = np * (CrackLength/NumberOfLengthElm);


CrackLengthRatio = CrackLength / PipeLength;
RemainThickness = CrackDepth*(R_out - R_in);
R_outCr = R_in + RemainThickness;
NlayersLengthRemain = ((PipeLength-(CrackLoc+CrackLength))/PipeLength)*NlayersLength;
Printf("Number of elements (in length) before the defect section is %f",NlayersLength);
Printf("Number of elements (in length) after the defect section is %f",NlayersLengthRemain);

IntactCoefMesh = CrackLoc/PipeLength;

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
Printf("Suface numbers are %f,%f,%f,%f,%f,%f",surfaceVector_bd_V1[0],surfaceVector_bd_V1[1],surfaceVector_bd_V1[2],surfaceVector_bd_V1[3],surfaceVector_bd_V1[4],surfaceVector_bd_V1[5]);

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
//----------------- Damage Itself (start)
//-------- Thin layer of the crack section
Point(3000) = {R_in, 0, CrackLoc, PointCoefMesh};
Point(4000) = {R_outCr, 0, CrackLoc, PointCoefMesh};
Line(3000) = {3000,4000};

surfaceVector_L_30[]=Extrude {{0,0,1},{0,0,CrackLoc},DmgAngle}{
        Line{3000}; Layers{DmgCoefMsh*NlayersThickness};Recombine;
};

surfaceVector_d_V30[]=Extrude {0,0,CrackLength} {
  Surface{3004}; Layers{NumberOfLengthElm}; Recombine;
};

//-------- The rest of the Pi/2 section
Point(300) = {R_in*Cos(DmgAngle), R_in*Sin(DmgAngle), CrackLoc, PointCoefMesh};
Point(400) = {R_out*Cos(DmgAngle), R_out*Sin(DmgAngle), CrackLoc, PointCoefMesh};
Line(300) = {300,400};

surfaceVector_L_3[]=Extrude {0,0,CrackLength}{
        Line{300}; Layers{NumberOfLengthElm};Recombine;
};

surfaceVector_d_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_L_3[1]}; Layers{DmgCoefMsh2*NlayersThickness};Recombine;
};
//----------------- Damage Itself (End)

surfaceVector_d_V4[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V3[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V5[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V4[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V6[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V5[0]}; Layers{NlayersThickness};Recombine;
};

//--------------------------------------- Damage Cont'd
//----------------- Inclined section from the entrance
//ElementLength = PipeLength/NlayersLength;
jj = 0;
th(0) = 0;
//Printf("CrackLength/(DmgCoefMsh*NlayersThickness) = %f",CrackLength/(DmgCoefMsh*NlayersThickness));
For jj In {1:DmgCoefMsh*NlayersThickness:1.0}
  //Printf("jj is %f",jj);
  th(jj) = (DmgAngle/(DmgCoefMsh*NlayersThickness))*jj;
  //Printf("For jj = %f th = %f",jj,th(jj));
  Point(10000+20*jj) = {R_outCr*Cos(th(jj-1)), R_outCr*Sin(th(jj-1)), CrackLoc , PointCoefMesh};
  Point(20000+50*jj) = {R_out*Cos(th(jj-1)), R_out*Sin(th(jj-1)), CrackLoc, PointCoefMesh};
  Line(20000+100*jj) = {10000+20*jj,20000+50*jj};

  Zcoord = CrackLoc + jj * ( (CrackLength-ZGap)/(DmgCoefMsh*NlayersThickness) );
  ZcoordNew = Zcoord - CrackLoc - ZGap;
  TempVal = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
  //Printf("Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal);
  If (TempVal !=0)
    ZcoordNew = ZcoordNew + (CrackLength/NumberOfLengthElm-TempVal);
  EndIf
  //TempVal2 = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
  //Printf("New Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal2);
  
  surfaceVector_L_300[]=Extrude {{0,0,1},{0, 0, CrackLoc},th(jj)-th(jj-1)}{
        Line{20000+100*jj}; Layers{1};Recombine;
        //Line{20000+100*jj}; Layers{((th(jj)-th(jj-1))/(DmgAngle))*DmgCoefMsh*NlayersThickness};Recombine;
  };
  
  If (ZcoordNew>=CrackLength/NumberOfLengthElm)
    nlayer = Ceil(Fabs(ZcoordNew/CrackLength)*NumberOfLengthElm); 
    surfaceVector_d_V300[]=Extrude {0,0,ZcoordNew} {
      Surface{surfaceVector_L_300[1]}; Layers{nlayer};Recombine;
    };
    Printf("For jj=%g, number of elements in axial direction is %g", jj, nlayer );
  EndIf


EndFor

//Printf("Volumes are: %f",VolumeNumbers);
//----------------- Inclined section from the end 
jj = 0;
th(0)=0;
For jj In {1:DmgCoefMsh*NlayersThickness-1:1.0}

  th(jj) = DmgAngle/(DmgCoefMsh*NlayersThickness)*jj;

  Point(100000+20*jj) = {R_outCr*Cos(th(jj)), R_outCr*Sin(th(jj)), CrackLoc+CrackLength , PointCoefMesh};
  Point(200000+50*jj) = {R_out*Cos(th(jj)), R_out*Sin(th(jj)), CrackLoc+CrackLength , PointCoefMesh};
  Line(200000+100*jj) = {100000+20*jj,200000+50*jj};

  Zcoord = (CrackLength) - jj * ( (CrackLength-ZGap)/(DmgCoefMsh*NlayersThickness));
  ZcoordNew = -Zcoord + ZGap;
  TempVal = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
  //Printf("Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal);
  ZcoordNew = ZcoordNew + (TempVal!=0)*(CrackLength/NumberOfLengthElm+TempVal);
  //TempVal2 = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
  //Printf("New Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal2);
  //Printf("Zcoord is %f",Zcoord);
  surfaceVector_L_3000[]=Extrude {{0,0,-1},{0, 0, CrackLoc+CrackLength},th(jj)-th(jj-1)}{
        Line{200000+100*jj}; Layers{1};Recombine;
  };
  
  If (Fabs(ZcoordNew)>=CrackLength/NumberOfLengthElm)
    nlayer = Round(Fabs((ZcoordNew/CrackLength))*NumberOfLengthElm);
    surfaceVector_d_V3000[]=Extrude {0,0,ZcoordNew} {
  	Surface{surfaceVector_L_3000[1]}; Layers{nlayer};Recombine;
    };
  InnerSurfNumber2(jj)=surfaceVector_d_V3000[5];
  EndIf

EndFor


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


//----------------------------------------- Meshing

//Physical Surface("Input") = {14,36,58,80,102};
//Physical Surface("Output")= {202447,202425,202513,202491,202469};

//Physical Surface("InnerSurf")={surfaceVector_bd_V1[5],surfaceVector_bd_V2[5],surfaceVector_bd_V3[5],surfaceVector_bd_V4[5],surfaceVector_bd_V5[5],surfaceVector_d_V3[5],surfaceVector_d_V30[5],surfaceVector_d_V4[5],surfaceVector_d_V5[5],surfaceVector_d_V6[5],surfaceVector_ad_V1[5],surfaceVector_ad_V2[5],surfaceVector_ad_V3[5],surfaceVector_ad_V4[5],surfaceVector_ad_V5[5]}

//Physical Surface("InnerSurfaceDefect") = {InnerSurfNumber2(1),InnerSurfNumber2(2),InnerSurfNumber2(3),InnerSurfNumber2(4),InnerSurfNumber2(5),InnerSurfNumber2(6),InnerSurfNumber2(7),InnerSurfNumber2(8),InnerSurfNumber2(9),InnerSurfNumber2(10),InnerSurfNumber2(11),InnerSurfNumber2(12),InnerSurfNumber2(13),InnerSurfNumber2(14),InnerSurfNumber2(15),InnerSurfNumber2(16),InnerSurfNumber2(17),InnerSurfNumber2(18),InnerSurfNumber2(19),InnerSurfNumber2(20),InnerSurfNumber2(21),InnerSurfNumber2(22),InnerSurfNumber2(23),InnerSurfNumber2(24),InnerSurfNumber1(1),InnerSurfNumber1(2),InnerSurfNumber1(3),InnerSurfNumber1(4),InnerSurfNumber1(5),InnerSurfNumber1(6),InnerSurfNumber1(7),InnerSurfNumber1(8),InnerSurfNumber1(9),InnerSurfNumber1(10),InnerSurfNumber1(11),InnerSurfNumber1(12),InnerSurfNumber1(13),InnerSurfNumber1(14),InnerSurfNumber1(15),InnerSurfNumber1(16),InnerSurfNumber1(17),InnerSurfNumber1(18),InnerSurfNumber1(19),InnerSurfNumber1(20),InnerSurfNumber1(21),InnerSurfNumber1(22),InnerSurfNumber1(23),InnerSurfNumber1(24),InnerSurfNumber1(25)};

//Physical Surface("OuterSurf")={surfaceVector_bd_V1[3],surfaceVector_bd_V2[3],surfaceVector_bd_V3[3],surfaceVector_bd_V4[3],surfaceVector_bd_V5[3],surfaceVector_d_V3[3],surfaceVector_d_V4[3],surfaceVector_d_V5[3],surfaceVector_d_V6[3],surfaceVector_ad_V1[3],surfaceVector_ad_V2[3],surfaceVector_ad_V3[3],surfaceVector_ad_V4[3],surfaceVector_ad_V5[3]};

//Physical Volume("Pipe")={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62};

//Printf("InnerSurfaceNumber2 is %f,%f,%f,%f,%f,%f",InnerSurfNumber2(0),InnerSurfNumber2(1),InnerSurfNumber2(2),InnerSurfNumber2(3),InnerSurfNumber2(4),InnerSurfNumber2(5));

Mesh.Algorithm = 6; // 2D mesh algorithm (1=MeshAdapt, 2=Automatic, 5=Delaunay, 6=Frontal, 7=BAMG, 8=DelQuad)
Mesh.Algorithm3D = 1; // 3D mesh algorithm (1=Delaunay, 2=New Delaunay, 4=Frontal, 5=Frontal Delaunay, 6=Frontal Hex, 7=MMG3D, 9=R-tree)
Mesh.SaveAll = 1; // Ignore physical definitions!
General.ExpertMode = 1;

/* surfaceVector contains in the following order:
    [0]	- front surface (opposed to source surface)
    [1] - extruded volume
    [2] - bottom surface
    [3] - right surface
    [4] - top surface
    [5] - left surface */


