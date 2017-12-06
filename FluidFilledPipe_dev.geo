// Gmsh project created on Wed Oct 26 09:00:10 2016

// ----------------------------------------- Inputs
// --------------- Pipe
Ro = 0.1542;
MshPoint = 0.0012;
L = 5; // Length of the pipe
NelementLength = 100; // Number of elements in z axis
NelementsCircum = 45;
// --------------- Fluid
d = 0.0508; //size of the side for the inner rectangular 
Msh = 1;
Ri = 0.14605; // Outer radius of fluid inside
th = Pi/4;
// ------------------------------------------------ 

Point(1) = {Ri*Cos(th), Ri*Sin(th), 0, MshPoint};
Point(2) = {Ro*Cos(th), Ro*Sin(th), 0, MshPoint};

Line(1) = {1,2};

Extrude {0,0,L} {
	Line{1}; Layers{NelementLength};
}


//+
SurfOut_1[] = Extrude {{0, 0, 1}, {0, 0, 0}, Pi/4} {
  Surface{5}; Layers{NelementsCircum/2};Recombine;
};

For ii In {1 : 7 : 1 }
  SurfOut~{ii+1}[]=Extrude {{0, 0, 1}, {0, 0, 0}, Pi/4} {
    Surface{SurfOut~{ii}[0]}; Layers{NelementsCircum/2};Recombine;
  };
EndFor


// -------------------------------------------------------------- Fluid Inside
// -------------------- Front
// Points
Point(0) = {0,0,0,Msh};
Point(8) = {d,0,0,Msh};
Point(15) = {d,d,0,Msh};
Point(18) = {0,d,0,Msh};
Point(20) = {-d,d,0,Msh};
Point(25) = {-d,0,0,Msh};
Point(30) = {-d,-d,0,Msh};
Point(35) = {0,-d,0,Msh};
Point(40) = {d,-d,0,Msh};

Point(50) = {Ri*Cos(th),Ri*Sin(th),0};
Point(55) = {Ri,0,0};
Point(60) = {-Ri*Cos(th),Ri*Sin(th),0};
Point(65) = {0,Ri,0};
Point(70) = {-Ri*Cos(th),-Ri*Sin(th),0};
Point(75) = {-Ri,0,0};
Point(80) = {Ri*Cos(th),-Ri*Sin(th),0};
Point(85) = {0,-Ri,0};

// Lines (Straight)
Line(10000) = {8,15};
Line(20) = {15,18};
Line(300) = {18,20};
Line(40) = {20,25};
Line(50) = {25,30};
Line(60) = {30,35};
Line(70) = {35,40};
Line(80) = {40,8};

Line(90) = {8,55};
Line(110)= {18,5};
Line(12000)= {25,47};
Line(130)= {35,67};

Line(14000)= {20,37};
Line(150)= {15,1};
Line(160)= {40,77};
Line(170)= {30,57};

Line(180)= {8,0};
Line(190)= {0,25};
Line(200)= {18,0};
Line(210)= {0,35};

// Lines (Circular)
Circle(1000) = {37,0,5};
Circle(1005) = {5,0,1};
Circle(1010) = {1,0,55};
Circle(1020) = {55,0,77};
Circle(1030) = {77,0,67};
Circle(1040) = {67,0,57};
Circle(1050) = {57,0,47};
Circle(1060) = {47,0,37};

//---------------- Surfaces
Line Loop(1100) = {40,12000,1060,-14000};
Surface(1101) = {1100};

Line Loop(1200) = {300,14000,1000,-110};
Surface(1201) = {1200};

Line Loop(1300) = {20,110,1005,-150};
Surface(1301) = {1300};

Line Loop(1400) = {10000,150,1010,-90};
Surface(1401) = {1400};

Line Loop(1500) = {80,90,1020,-160};
Surface(1501) = {1500};

Line Loop(1600) = {70,160,1030,-130};
Surface(1601) = {1600};

Line Loop(1700) = {60,130,1040,-170};
Surface(1701) = {1700};

Line Loop(1800) = {50,170,1050,-12000};
Surface(1801) = {1800};

Line Loop(1900) = {40,-190,-200,300};
Surface(1901) = {1900};

Line Loop(2000) = {20,200,-180,10000};
Surface(2001) = {2000};

Line Loop(2100) = {-80,-70,-210,-180};
Surface(2101) = {2100};

Line Loop(2200) = {50,60,-210,190};
Surface(2201) = {2200};
//-------------------------

// ----------------- Extrusion
Fluid[]=Extrude {0,0,L} {
  Surface{1101,1201,1301,1401,1501,1601,1701,1801,1901,2001,2101,2201}; Layers{NelementLength};Recombine;
};

// ------------------- Meshing
Transfinite Line {10000, 20, 300, 40, 50, 60, 70, 80,180, 190, 200, 210} = NelementsCircum/2+1;
Transfinite Line {1000,1005, 1010, 1020, 1030,1040, 1050, 1060} = NelementsCircum/2;
Printf("Number of elements are: %f", NelementsCircum/2);
Transfinite Line {90,110,12000,130,14000,150,160, 170} = 30 Using Progression 0.9;
Transfinite Surface "*";
Recombine Surface "*";

//-------------------- Physical Volumes
// Pipe
Physical Surface("Side1") = {124, 146, 168, 14, 36, 58, 80, 102};
Physical Surface("Side2") = {22, 44, 66, 88, 110, 132, 154, 176};
Physical Surface("Outer") = {18, 40, 62, 84, 106, 128, 150, 172};
Physical Surface("Inner") = {26, 48, 70, 92, 114, 136, 158, 180};
Physical Volume("Body") = {1,2,3,4,5,6,7,8};
// Fluid
Physical Surface("Fluid_Side1") = {1101, 1201, 1301, 1401, 1501, 1601, 1701, 1801, 1901, 2001, 2101, 2201};
Physical Surface("Fluid_Side2") = {14044, 14066, 14088, 14110, 14132, 14154, 14176, 14022, 14198, 14220, 14242, 14264};
Physical Volume("Fluid") = {9,10,11,12,13,14,15,16,17,18,19,20};




