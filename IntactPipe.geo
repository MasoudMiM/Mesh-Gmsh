

Point(1) = {0.14605, 0, 0, 0.0012};
Point(2) = {0.1524, 0, 0, 0.0012};

Line(1) = {1,2};

Extrude {0,0,5} {
	Line{1}; Layers{500};
}


//+
Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{5}; Layers{75};Recombine;
}

Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{27}; Layers{75};Recombine;
}

Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{49}; Layers{75};Recombine;
}

Extrude {{0, 0, 1}, {0, 0, 0}, Pi/2} {
  Surface{71}; Layers{75};Recombine;
}

Physical Surface("Side1") = {14, 80, 58, 36};
Physical Surface("Side2") = {66, 44, 22, 88};
Physical Surface("Outer") = {62, 40, 18, 84};
Physical Surface("Inner") = {92, 70, 48, 26};
Physical Volume("Body") = {3, 2, 1, 4};

Coherence Mesh;

