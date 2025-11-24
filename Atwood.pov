#include "colors.inc"
#include "textures.inc"
#include "shapes3.inc"

//Variables necessary for calculations
#declare displacements = array[5] {0, 0, 0, 0, 0};
#declare masses = array[5][2] {{1, 0.1}, {1, 0.25}, {1, 0.5}, {1, 0.75}, {1, 0.9}};
#declare maxDist = 0.75537777505;
#declare maxTime = array[5] {sqrt(2.2*maxDist/8.82), 
                             sqrt(2.5*maxDist/7.35), 
                             sqrt(3*maxDist/4.9), 
                             sqrt(3.5*maxDist/2.45), 
                             sqrt(3.8*maxDist/0.98)
                            } //Calculate total time for the slowest system

//Calculate displacement
#macro updateDisplacements(time)
    #for(i, 0, 4)
        #local acceleration = (9.8*(masses[i][0]-masses[i][1]))/(masses[i][0]+masses[i][1]);
        #declare displacements[i] = 0.5*acceleration*pow(time, 2);
        #if(displacements[i] > maxDist)
            #declare displacements[i] = maxDist;
        #end
    #end
#end        
                             
#macro displayClock(num)
    #if(displacements[num] < maxDist)
        text{
         ttf "timrom.ttf" concat("t= ", str((clock-5), 0, 3), "s") 0.5, 0
         pigment{color rgb<1, 1, 1>}
         scale 0.1
         translate<(num-2)*0.675-0.19, 3.25, 0>
        }
    #else
        text{
         ttf "timrom.ttf", concat("t= ", str(maxTime[num], 0, 3), "s") 0.5, 0
         pigment{color rgb<0, 1, 0>}
         scale 0.1
         translate<(num-2)*0.675-0.19, 3.25, 0>
        }
    #end   
#end

#if(clock < 5)
 camera{
  location<-3, 2.5, 0>
  look_at<-3, 2.5, 1>
  translate<(clock/5)*6, 0, 0>
 } 
#else
 camera{
  location<0, 2.5, -2.65>
  look_at<0, 2.75, 0>
 }
 updateDisplacements(clock-5)
 displayClock(0)
 displayClock(1)
 displayClock(2)
 displayClock(3)
 displayClock(4)
#end



light_source{
 <500, 500, -500>
 color rgb<1,1,1>
}

background{
 color rgb<0, 0.1, 0.75>
}

plane{
 <0, 1, 0>, 1
 texture{
    Water
    pigment{
     hexagon color rgbt<1,0.5,0, 0>
     color rgbt<0.25,0.75,0.1, 0.25>
     scale 0.25
    }
    normal{bumps 0.02 turbulence 0.05 scale 0.05}
 }
}


//Atwood Machine 
union{
 //Block 1
 difference{
  object{
   Round_Box(<0.5, 1.5, 1.5>, <1, 2, 2>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.05}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "1kg"
   1, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.3
   translate<.55, 1.675, 1.45>
  }
  translate<-0.5, -1*displacements[0], 0>
 }

 //Block 2
 difference{
  object{
   Round_Box(<-0.5515748685, 1.603149737, 1.5515748685>, <-0.9484251315, 2, 1.9484251315>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.025}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "0.1kg"
   1.5, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.15
   translate<-0.92, 1.75, 1.45>
  }
  translate<0.5, displacements[0], 0>
 }

 //Pulley system
 difference{
  cylinder{
   <0, 3, 1.7>, <0, 3, 1.8>, 0.25
   texture{Chrome_Metal
   pigment{color rgb<0, 0, 0>}}
  }
  torus{
   0.25, 0.045
   rotate<90, 0, 0>
   translate<0, 3, 1.75>
   texture{Chrome_Metal}
  }
  difference{
   cylinder{
    <0, 3, 1.69>, <0, 3, 1.71>, 0.2
    texture{Chrome_Metal}
   }
   cylinder{
    <0, 3, 1.68>, <0, 3, 1.72>, 0.05
    texture{Chrome_Metal}
   }
  }
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
 }
 difference {
  cylinder {
   <1.065, -0.00125, 1.185>, <1.065, 0.00125, 1.185>, 0.05
   texture{Copper_Metal}
  }
  prism {
   -0.00126, 0.00126, 13,
   <1.065, 1.06>, <1.0575, 1.055>, <1.055, 1.0575>,
   <1.06, 1.065>, <1.055, 1.0725>, <1.0575, 1.075>,
   <1.065, 1.07>, <1.0725, 1.075>, <1.075, 1.0725>,
   <1.07, 1.065>, <1.075, 1.0575>, <1.0725, 1.055>,
   <1.065, 1.06>
   texture{Copper_Metal}
   
   translate<0, 0, 0.12>   
  }
  rotate<-90, 0, 0>
  translate<-1.065, 1.8, 1.625>
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
  translate<0, 0, 0.17>
 }
 sphere_sweep{
  b_spline
  7,
  <-0.25, -3.5+(displacements[0]*6.5), 1.75>, 0.02,
  <-0.25, 3, 1.75>, 0.02,
  <(-sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0, 3.25, 1.75>, 0.02,
  <(sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0.25, 3, 1.75>, 0.02,
  <0.25, -3.5-(displacements[0]*6.5), 1.75>, 0.02
  tolerance 0.1
  texture{
   pigment{color DarkWood}
  }
  normal{spiral1 3 bump_size 0.1 turbulence 0.05 sine_wave frequency 75}
 }
 translate<-2.2, 1-maxDist, 0>
}

//Atwood Machine 
union{
 //Block 1
 difference{
  object{
   Round_Box(<0.5, 1.5, 1.5>, <1, 2, 2>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.05}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "1kg"
   1, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.3
   translate<.55, 1.675, 1.45>
  }
  translate<-0.5, -1*displacements[1], 0>
 }

 //Block 2
 difference{
  object{
   Round_Box(<-0.5515748685, 1.603149737, 1.5515748685>, <-0.9484251315, 2, 1.9484251315>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.025}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "0.25kg"
   1.5, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.125
   translate<-0.92, 1.75, 1.45>
  }
  translate<0.5, displacements[1], 0>
 }

 //Pulley system
 difference{
  cylinder{
   <0, 3, 1.7>, <0, 3, 1.8>, 0.25
   texture{Chrome_Metal
   pigment{color rgb<0, 0, 0>}}
  }
  torus{
   0.25, 0.045
   rotate<90, 0, 0>
   translate<0, 3, 1.75>
   texture{Chrome_Metal}
  }
  difference{
   cylinder{
    <0, 3, 1.69>, <0, 3, 1.71>, 0.2
    texture{Chrome_Metal}
   }
   cylinder{
    <0, 3, 1.68>, <0, 3, 1.72>, 0.05
    texture{Chrome_Metal}
   }
  }
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
 }
 difference {
  cylinder {
   <1.065, -0.00125, 1.185>, <1.065, 0.00125, 1.185>, 0.05
   texture{Copper_Metal}
  }
  prism {
   -0.00126, 0.00126, 13,
   <1.065, 1.06>, <1.0575, 1.055>, <1.055, 1.0575>,
   <1.06, 1.065>, <1.055, 1.0725>, <1.0575, 1.075>,
   <1.065, 1.07>, <1.0725, 1.075>, <1.075, 1.0725>,
   <1.07, 1.065>, <1.075, 1.0575>, <1.0725, 1.055>,
   <1.065, 1.06>
   texture{Copper_Metal}
   
   translate<0, 0, 0.12>   
  }
  rotate<-90, 0, 0>
  translate<-1.065, 1.8, 1.625>
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
  translate<0, 0, 0.17>
 }
 sphere_sweep{
  b_spline
  7,
  <-0.25, -3.5+(displacements[1]*6.5), 1.75>, 0.02,
  <-0.25, 3, 1.75>, 0.02,
  <(-sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0, 3.25, 1.75>, 0.02,
  <(sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0.25, 3, 1.75>, 0.02,
  <0.25, -3.5-(displacements[1]*6.5), 1.75>, 0.02
  tolerance 0.1
  texture{
   pigment{color DarkWood}
  }
  normal{spiral1 3 bump_size 0.1 turbulence 0.05 sine_wave frequency 75}
 }
 translate<-1.1, 1-maxDist, 0>
}
                
//Atwood Machine 
union{
 //Block 1
 difference{
  object{
   Round_Box(<0.5, 1.5, 1.5>, <1, 2, 2>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.05}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "1kg"
   1, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.3
   translate<.55, 1.675, 1.45>
  }
  translate<-0.5, -1*displacements[2], 0>
 }

 //Block 2
 difference{
  object{
   Round_Box(<-0.5515748685, 1.603149737, 1.5515748685>, <-0.9484251315, 2, 1.9484251315>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.025}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "0.5kg"
   1.5, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.15
   translate<-0.92, 1.75, 1.45>
  }
  translate<0.5, displacements[2], 0>
 }

 //Pulley system
 difference{
  cylinder{
   <0, 3, 1.7>, <0, 3, 1.8>, 0.25
   texture{Chrome_Metal
   pigment{color rgb<0, 0, 0>}}
  }
  torus{
   0.25, 0.045
   rotate<90, 0, 0>
   translate<0, 3, 1.75>
   texture{Chrome_Metal}
  }
  difference{
   cylinder{
    <0, 3, 1.69>, <0, 3, 1.71>, 0.2
    texture{Chrome_Metal}
   }
   cylinder{
    <0, 3, 1.68>, <0, 3, 1.72>, 0.05
    texture{Chrome_Metal}
   }
  }
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
 }
 difference {
  cylinder {
   <1.065, -0.00125, 1.185>, <1.065, 0.00125, 1.185>, 0.05
   texture{Copper_Metal}
  }
  prism {
   -0.00126, 0.00126, 13,
   <1.065, 1.06>, <1.0575, 1.055>, <1.055, 1.0575>,
   <1.06, 1.065>, <1.055, 1.0725>, <1.0575, 1.075>,
   <1.065, 1.07>, <1.0725, 1.075>, <1.075, 1.0725>,
   <1.07, 1.065>, <1.075, 1.0575>, <1.0725, 1.055>,
   <1.065, 1.06>
   texture{Copper_Metal}
   
   translate<0, 0, 0.12>   
  }
  rotate<-90, 0, 0>
  translate<-1.065, 1.8, 1.625>
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
  translate<0, 0, 0.17>
 }
 sphere_sweep{
  b_spline
  7,
  <-0.25, -3.5+(displacements[2]*6.5), 1.75>, 0.02,
  <-0.25, 3, 1.75>, 0.02,
  <(-sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0, 3.25, 1.75>, 0.02,
  <(sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0.25, 3, 1.75>, 0.02,
  <0.25, -3.5-(displacements[2]*6.5), 1.75>, 0.02
  tolerance 0.1
  texture{
   pigment{color DarkWood}
  }
  normal{spiral1 3 bump_size 0.1 turbulence 0.05 sine_wave frequency 75}
 }
 translate<0, 1-maxDist, 0>
}

//Atwood Machine 
union{
 //Block 1
 difference{
  object{
   Round_Box(<0.5, 1.5, 1.5>, <1, 2, 2>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.05}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "1kg"
   1, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.3
   translate<.55, 1.675, 1.45>
  }
  translate<-0.5, -1*displacements[3], 0>
 }

 //Block 2
 difference{
  object{
   Round_Box(<-0.5515748685, 1.603149737, 1.5515748685>, <-0.9484251315, 2, 1.9484251315>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.025}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "0.75kg"
   1.5, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.125
   translate<-0.92, 1.75, 1.45>
  }
  translate<0.5, displacements[3], 0>
 }

 //Pulley system
 difference{
  cylinder{
   <0, 3, 1.7>, <0, 3, 1.8>, 0.25
   texture{Chrome_Metal
   pigment{color rgb<0, 0, 0>}}
  }
  torus{
   0.25, 0.045
   rotate<90, 0, 0>
   translate<0, 3, 1.75>
   texture{Chrome_Metal}
  }
  difference{
   cylinder{
    <0, 3, 1.69>, <0, 3, 1.71>, 0.2
    texture{Chrome_Metal}
   }
   cylinder{
    <0, 3, 1.68>, <0, 3, 1.72>, 0.05
    texture{Chrome_Metal}
   }
  }
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
 }
 difference {
  cylinder {
   <1.065, -0.00125, 1.185>, <1.065, 0.00125, 1.185>, 0.05
   texture{Copper_Metal}
  }
  prism {
   -0.00126, 0.00126, 13,
   <1.065, 1.06>, <1.0575, 1.055>, <1.055, 1.0575>,
   <1.06, 1.065>, <1.055, 1.0725>, <1.0575, 1.075>,
   <1.065, 1.07>, <1.0725, 1.075>, <1.075, 1.0725>,
   <1.07, 1.065>, <1.075, 1.0575>, <1.0725, 1.055>,
   <1.065, 1.06>
   texture{Copper_Metal}
   
   translate<0, 0, 0.12>   
  }
  rotate<-90, 0, 0>
  translate<-1.065, 1.8, 1.625>
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
  translate<0, 0, 0.17>
 }
 sphere_sweep{
  b_spline
  7,
  <-0.25, -3.5+(displacements[3]*6.5), 1.75>, 0.02,
  <-0.25, 3, 1.75>, 0.02,
  <(-sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0, 3.25, 1.75>, 0.02,
  <(sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0.25, 3, 1.75>, 0.02,
  <0.25, -3.5-(displacements[3]*6.5), 1.75>, 0.02
  tolerance 0.1
  texture{
   pigment{color DarkWood}
  }
  normal{spiral1 3 bump_size 0.1 turbulence 0.05 sine_wave frequency 75}
 }
 translate<1.1, 1-maxDist, 0>
}

//Atwood Machine 
union{
 //Block 1
 difference{
  object{
   Round_Box(<0.5, 1.5, 1.5>, <1, 2, 2>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.05}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "1kg"
   1, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.3
   translate<.55, 1.675, 1.45>
  }
  translate<-0.5, -1*displacements[4], 0>
 }

 //Block 2
 difference{
  object{
   Round_Box(<-0.5515748685, 1.603149737, 1.5515748685>, <-0.9484251315, 2, 1.9484251315>, 0.01, 0)
    texture{Pink_Granite scale 0.05}
    normal{agate 0.75 turbulence 0.1 scale 0.025}
    finish {phong 0.5}
  }
  text{
   ttf"timrom.ttf", "0.9kg"
   1.5, 0
   pigment{color Blue}
   normal{agate 0.5 turbulence 0.1 scale 0.05}
   finish{phong 1}
   scale 0.15
   translate<-0.92, 1.75, 1.45>
  }
  translate<0.5, displacements[4], 0>
 }

 //Pulley system
 difference{
  cylinder{
   <0, 3, 1.7>, <0, 3, 1.8>, 0.25
   texture{Chrome_Metal
   pigment{color rgb<0, 0, 0>}}
  }
  torus{
   0.25, 0.045
   rotate<90, 0, 0>
   translate<0, 3, 1.75>
   texture{Chrome_Metal}
  }
  difference{
   cylinder{
    <0, 3, 1.69>, <0, 3, 1.71>, 0.2
    texture{Chrome_Metal}
   }
   cylinder{
    <0, 3, 1.68>, <0, 3, 1.72>, 0.05
    texture{Chrome_Metal}
   }
  }
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
 }
 difference {
  cylinder {
   <1.065, -0.00125, 1.185>, <1.065, 0.00125, 1.185>, 0.05
   texture{Copper_Metal}
  }
  prism {
   -0.00126, 0.00126, 13,
   <1.065, 1.06>, <1.0575, 1.055>, <1.055, 1.0575>,
   <1.06, 1.065>, <1.055, 1.0725>, <1.0575, 1.075>,
   <1.065, 1.07>, <1.0725, 1.075>, <1.075, 1.0725>,
   <1.07, 1.065>, <1.075, 1.0575>, <1.0725, 1.055>,
   <1.065, 1.06>
   texture{Copper_Metal}
   
   translate<0, 0, 0.12>   
  }
  rotate<-90, 0, 0>
  translate<-1.065, 1.8, 1.625>
 }
 union{
  prism{
   -0.025, 0.025, 5
   <-0.05, -0.125>, <0.05, -0.125>,
   <0.15, 0.15>, <-0.15, 0.15>,
   <-0.05, -0.125>
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
   rotate<-90, 0, 0>
   translate<0, 3.125, 1.665>
  }
  cylinder{
   <0, 3, 1.64>, <0, 3, 1.69>, 0.05
   pigment{color rgb<0.15, 0.15, 0.15>}
   normal{bumps 0.5 turbulence 0.25}
   finish{metallic 1 phong 1}
  }
  translate<0, 0, 0.17>
 }
 sphere_sweep{
  b_spline
  7,
  <-0.25, -3.5+(displacements[4]*6.5), 1.75>, 0.02,
  <-0.25, 3, 1.75>, 0.02,
  <(-sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0, 3.25, 1.75>, 0.02,
  <(sqrt(2)/2)*0.25, 3+(sqrt(2)/2)*0.25, 1.75>, 0.02,
  <0.25, 3, 1.75>, 0.02,
  <0.25, -3.5-(displacements[4]*6.5), 1.75>, 0.02
  tolerance 0.1
  texture{
   pigment{color DarkWood}
  }
  normal{spiral1 3 bump_size 0.1 turbulence 0.05 sine_wave frequency 75}
 }
 translate<2.2, 1-maxDist, 0>
}

//Just the sky (courtesy of f-lohmueller.de)-------------------------------------------------------
#declare T_Cloud2_Lo =
texture {
    pigment { bozo
        turbulence 1.5
        octaves 10
        omega 0.5
        lambda 2.5
        color_map { [0.0 color rgbf<0.85, 0.85, 0.85, 0.00>*1.0 ]
                    [0.5 color rgbf<0.95, 0.95, 0.95, 0.90>*1.12  ]
                    [0.7 color rgbf<1, 1, 1, 1> ]
                    [1.0 color rgbf<1, 1, 1, 1> ] }
    }
        #if (version = 3.7 )  finish {emission 0.95 diffuse 0}
        #else                 finish { ambient 0.95 diffuse 0}
        #end 
}
//--------------------------- 
#declare T_Cloud3_Lo =
texture {
    pigment { bozo
        turbulence 0.8 //0.6
        octaves 10
        omega 0.5
        lambda 2.5
        color_map { [0.0 color rgbf<0.95, 0.95, 0.95, 0.00>*1.2]
                    [0.4 color rgbf<0.90, 0.90, 0.90, 0.90>*1]
                    [0.7 color rgbf<1, 1, 1, 1> ]
                    [1.0 color rgbf<1, 1, 1, 1> ] }
           }
        #if (version = 3.7 )  finish {emission 1 diffuse 0}
        #else                 finish { ambient 1 diffuse 0}
        #end 
}
texture {
    pigment { bozo
        turbulence 0.8 //0.6
        octaves 10
        omega 0.5
        lambda 2.5
        color_map { [0.00 color rgbf<.85, .85, .85, 0.5>*1.5]
                    [0.35 color rgbf<.95, .95, .95, .95>*1.1]
                    [0.50 color rgbf<1, 1, 1, 1> ]
                    [1.00 color rgbf<1, 1, 1, 1> ] }        
        }
        finish {emission 1 diffuse 0}
scale 0.9
translate y*-0.15
}


// Darin Dugger's DD_Cloud_Sky texture mapped onto a pair of planes
//  first cloud level  500
// second cloud level 3000 

// "hollow" added by Friedrich A.Lohmueller,2000
// for using together with fog!


#declare O_Cloud2_Lo =
union {
 plane { <0,1,0>, 500 hollow //!!!!
        texture { T_Cloud3_Lo  scale 500}}
    
 plane { <0,1,0>, 3000 hollow  //!!!!
        texture {T_Cloud2_Lo scale <900,1,3000> 
                 translate <3000,0,0> rotate <0,-30,0>}}

 plane { <0,1,0> , 10000  hollow
        texture{ pigment {color SkyBlue*0.20}
                 finish {ambient 1 diffuse 0}}}
scale<1.5,1,1.25>
}//--------------------------------------------------



object{O_Cloud2_Lo rotate<0,0,0> translate<0,0,0>}


//---------------------------------------------------
 
// fog at the horizon
fog{fog_type   2
    distance   50
    color      rgb<1,1,1>*0.75
    fog_offset 0.1
    fog_alt    5
    turbulence 0.8}
 
//----------------------------------------------------

