// Gmsh project created on Wed Oct 26 09:00:10 2016


PipeLength = 5;
NlayersThickness = 75;
NlayersLength = 500;

CrackDepth = 3/6;
CrackLength = 0.1;
NumberOfLengthElm = 100;// (CrackLength/PipeLength)*NlayersLength; or 200  (Number of elements for the carck section)
DmgAngle = Pi/4; // Should be less than Pi/2 for this code!
np = 6; // number of elements for crack's width

R_in = 0.14605;
R_out = 0.1524;
CrackLoc = 1.5; // corner of the crack


DmgCoefMsh2 = (Pi/2-DmgAngle)/(Pi/2);
Printf("Element size (in length) is %f", PipeLength/NlayersLength);
ZGap = np * (CrackLength/NumberOfLengthElm);
ZGap_angle = ZGap/0.1524;

CrackLengthRatio = CrackLength / PipeLength;
RemainThickness = CrackDepth*(R_out - R_in);
R_outCr = R_in + RemainThickness;
NlayersLengthRemain = ((PipeLength-(CrackLoc+CrackLength))/PipeLength)*NlayersLength;
Printf("Number of elements (in length) before the defect section is %f",NlayersLength);
Printf("Number of elements (in length) after the defect section is %f",NlayersLengthRemain);

IntactCoefMesh = CrackLoc/PipeLength;

//-- horizontal part
l1 = 0.5;
DmgAngle2 = Pi/20;
//DmgAngle = DmgAngle - DmgAngle2;
DmgCoefMsh = (DmgAngle-DmgAngle2)/(Pi/2);

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
//----------------- Damage Itself (start)
//-------- Thin layer of the crack section
Point(3000) = {R_in, 0, CrackLoc, PointCoefMesh};
Point(4000) = {R_outCr, 0, CrackLoc, PointCoefMesh};
Line(3000) = {3000,4000};

surfaceVector_L_30[]=Extrude {{0,0,1},{0,0,CrackLoc},DmgAngle-DmgAngle2}{
        Line{3000}; Layers{( (DmgAngle-DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_d_V30[]=Extrude {0,0,CrackLength} {
  Surface{3004}; Layers{NumberOfLengthElm}; Recombine;
};

//-------- The rest of the Pi/2 section
Point(300) = {R_in*Cos(DmgAngle-DmgAngle2), R_in*Sin(DmgAngle-DmgAngle2), CrackLoc, PointCoefMesh};
Point(400) = {R_out*Cos(DmgAngle-DmgAngle2), R_out*Sin(DmgAngle-DmgAngle2), CrackLoc, PointCoefMesh};
Line(300) = {300,400};

surfaceVector_L_3[]=Extrude {0,0,CrackLength}{
        Line{300}; Layers{NumberOfLengthElm};Recombine;
};

surfaceVector_d_V3[]=Extrude {{0, 0, 1}, {0, 0, 0}, DmgAngle2} {
  Surface{surfaceVector_L_3[1]}; Layers{( DmgAngle2/(Pi/2) )*NlayersThickness};Recombine;
};
//----------------- Damage Itself (End)

surfaceVector_d_V4[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2-DmgAngle} {
  Surface{surfaceVector_d_V3[0]}; Layers{( (Pi/2-DmgAngle)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_d_V5[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V4[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V6[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V5[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V7[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V6[0]}; Layers{NlayersThickness};Recombine;
};

//--------------------------------------- Damage Cont'd
//----------------- Inclined section from the entrance
//ElementLength = PipeLength/NlayersLength;
jj = 0;
th(0) = 0;
//Printf("CrackLength/(DmgCoefMsh*NlayersThickness) = %f",CrackLength/(DmgCoefMsh*NlayersThickness));
For jj In {1:DmgCoefMsh*NlayersThickness:1.0}
  //Printf("jj is %f",jj);
  th(jj) = ((DmgAngle-DmgAngle2)/(DmgCoefMsh*NlayersThickness))*jj;
  Zcoord = CrackLoc + jj * ( (CrackLength-ZGap)/(DmgCoefMsh*NlayersThickness) );
  ZcoordNew = Zcoord - CrackLoc - ZGap;

  If (ZcoordNew>=ZGap)
    //Printf("For jj = %f th = %f",jj,th(jj));
    Point(10000+20*jj) = {R_outCr*Cos(th(jj-1)), R_outCr*Sin(th(jj-1)), CrackLoc , PointCoefMesh};
    Point(20000+50*jj) = {R_out*Cos(th(jj-1)), R_out*Sin(th(jj-1)), CrackLoc, PointCoefMesh};
    Line(20000+100*jj) = {10000+20*jj,20000+50*jj};

    
    TempVal = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
    //Printf("Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal);
    If (TempVal !=0)
      ZcoordNew = ZcoordNew + (CrackLength/NumberOfLengthElm-TempVal);
    EndIf
    //TempVal2 = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
    //Printf("New Fmod for Fabs(%f), %f is %f",ZcoordNew,CrackLength/NumberOfLengthElm,TempVal2);
  
    surfaceVector_L_300[]=Extrude {{0,0,1},{0, 0, CrackLoc},th(jj)-th(jj-1)}{
        Line{20000+100*jj}; Layers{1};Recombine;
        //Line{20000+100*jj}; Layers{((th(jj)-th(jj-1))/( (DmgAngle-DmgAngle2) ))*DmgCoefMsh*NlayersThickness};Recombine;
    };
  
  
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

  th(jj) = (DmgAngle-DmgAngle2)/(DmgCoefMsh*NlayersThickness)*jj;
  Zcoord = (CrackLength) - jj * ( (CrackLength-ZGap)/(DmgCoefMsh*NlayersThickness));
  ZcoordNew = -Zcoord + ZGap;

  If (Fabs(ZcoordNew)>=ZGap)
    Point(100000+20*jj) = {R_outCr*Cos(th(jj)), R_outCr*Sin(th(jj)), CrackLoc+CrackLength , PointCoefMesh};
    Point(200000+50*jj) = {R_out*Cos(th(jj)), R_out*Sin(th(jj)), CrackLoc+CrackLength , PointCoefMesh};
    Line(200000+100*jj) = {100000+20*jj,200000+50*jj};
    
    TempVal = Fmod ( Fabs(ZcoordNew), CrackLength/NumberOfLengthElm );
  
    ZcoordNew = ZcoordNew + (TempVal!=0)*(CrackLength/NumberOfLengthElm+TempVal);
  
  
    surfaceVector_L_3000[]=Extrude {{0,0,-1},{0, 0, CrackLoc+CrackLength},th(jj)-th(jj-1)}{
          Line{200000+100*jj}; Layers{1};Recombine;
    };
  
  
    nlayer = Round(Fabs((ZcoordNew/CrackLength))*NumberOfLengthElm);
    surfaceVector_d_V3000[]=Extrude {0,0,ZcoordNew} {
  	Surface{surfaceVector_L_3000[1]}; Layers{nlayer};Recombine;
    };
    InnerSurfNumber2(jj)=surfaceVector_d_V3000[5];
  Else
    th_temp = th(jj);
  EndIf

EndFor


//----------------------------------------- Horizontal Part
//############################## CHANGE THIS ACCORDING TO THE VALUE FOR np TO GET A CORRECT MESH!
tth = th(2);
nlayer_th = 2;
//##############################################################################################

Point(70000) = {R_in, 0, CrackLoc+CrackLength, PointCoefMesh};
Point(80000) = {R_out, 0, CrackLoc+CrackLength, PointCoefMesh};
Line(70000) = {70000,80000};

surfaceVector_L_300000[]=Extrude {{0,0,1},{0,0,CrackLoc+CrackLength},DmgAngle-DmgAngle2-tth}{
        Line{70000}; Layers{( (DmgAngle-DmgAngle2-tth)/(Pi/2))*NlayersThickness};Recombine;
};

surfaceVector_d_V300[]=Extrude {0,0,l1} {
  Surface{surfaceVector_L_300000[1]}; Layers{500}; Recombine;
};

Point(300000) = {R_in*Cos(DmgAngle-DmgAngle2-tth), R_in*Sin(DmgAngle-DmgAngle2-tth), CrackLoc+CrackLength, PointCoefMesh};
Point(400000) = {R_outCr*Cos(DmgAngle-DmgAngle2-tth), R_outCr*Sin(DmgAngle-DmgAngle2-tth), CrackLoc+CrackLength, PointCoefMesh};
Line(300000) = {300000,400000};

surfaceVector_L_30[]=Extrude {0,0,l1}{
        Line{300000}; Layers{500};Recombine;
};

surfaceVector_d_V30[]=Extrude {{0, 0, 1}, {0, 0, 0},tth} {
  Surface{surfaceVector_L_30[1]}; Layers{nlayer_th};Recombine;
};



Point(800000) = {R_in*Cos(DmgAngle-DmgAngle2), R_in*Sin(DmgAngle-DmgAngle2), CrackLoc+CrackLength, PointCoefMesh};
Point(900000) = {R_out*Cos(DmgAngle-DmgAngle2), R_out*Sin(DmgAngle-DmgAngle2), CrackLoc+CrackLength, PointCoefMesh};
Line(800000) = {800000,900000};

surfaceVector_L_330[]=Extrude {0,0,l1}{
        Line{800000}; Layers{500};Recombine;
};

surfaceVector_d_V330[]=Extrude {{0, 0, 1}, {0, 0, 0},(DmgAngle2)} {
  Surface{surfaceVector_L_330[1]}; Layers{( (DmgAngle2)/(Pi/2) )*NlayersThickness};Recombine;
};

surfaceVector_d_V530[]=Extrude {{0, 0, 1}, {0, 0, 0},(Pi/2-DmgAngle)} {
  Surface{surfaceVector_d_V330[0]}; Layers{( (Pi/2-DmgAngle)/(Pi/2) )*NlayersThickness};Recombine;
};



surfaceVector_d_V40[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V530[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V50[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V40[0]}; Layers{NlayersThickness};Recombine;
};

surfaceVector_d_V60[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{surfaceVector_d_V50[0]}; Layers{NlayersThickness};Recombine;
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


