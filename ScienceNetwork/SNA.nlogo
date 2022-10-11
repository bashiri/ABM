

extensions [matrix]                       ;The matrix extension adds a new matrix data structure to NetLogo. A matrix is a mutable 2-dimensional array containing only numbers.

breed [Normal Normals]                    ;custom kinds or breeds of turtles

globals[                                  ;Network properties - Macro Level Properties

  index
  temp-Matrix
  num-of-researchers

  row

  indexArticle
  indexConnection
  indexDegree
  indexBetweenness
  indexCluster

  currentYear

  no-of-sorting-level

  total-Article                           ; these variables will apply in computational model of each properties
  total-IndexArticle
  total-Betweenness
  total-Cluster
  total-Connection
  total-Degree

  elapsed-time

  articleStep
  connectionStep
  degreeStep
  betweennessStep
  clusterStep

]


turtles-own
[
    t-Article
    t-Cluster
    t-Citation
    t-IndexArticle
    t-Betweenness
    t-Connection
    t-Degree
    N-Degree
]


to Setup-Network
  clear-all

  set-patch-size 6                    ;environment's size

  set index 0
  set row 0
  set num-of-researchers 0
  set currentYear 1398
  set elapsed-time 0

  ask patches [set pcolor bgColor]
  set-default-shape turtles "Person"

  make-nodes nobody                   ;this funtion creats nodes in graph
  make-nodes turtle 0

  readingInputData                    ;reading data from file/data.txt

  reset-ticks

end


To readingInputData

  file-open "files/data.txt"

  while[not file-at-end?] [
      let line file-read
      set num-of-researchers num-of-researchers + 1
  ]
  file-close

  set temp-Matrix matrix:make-constant num-of-researchers 9 0   ;initializaion temp matrix by zero

  file-open "files/data.txt"

  while[not file-at-end?] [                                     ;converting data from file into temp-Matrix
      let line file-read

      if row < num-of-researchers [
         matrix:set temp-Matrix row 0 item 0 line               ;assign row
         matrix:set temp-Matrix row 1 item 1 line               ;assign all-citations
         matrix:set temp-Matrix row 2 item 2 line               ;assign article
         matrix:set temp-Matrix row 3 item 3 line               ;assign index
         matrix:set temp-Matrix row 4 item 4 line               ;assign betweenness
         matrix:set temp-Matrix row 5 item 5 line               ;assign cluster
         matrix:set temp-Matrix row 6 item 6 line               ;assign n-of-connections
         matrix:set temp-Matrix row 7 item 7 line               ;assign n-degree
         matrix:set temp-Matrix row 8 item 8 line               ;assign last item
      ]

      set row row + 1
  ]
  file-close
  set row 0                                                     ; reset row indexer

end


to make-nodes [old-node]
   create-turtles 1 [
       set color red
       if old-node != nobody [
          create-link-with old-node [ set color green ]
          move-to old-node
          fd 8
       ]
  ]
end

to Sort-Network

   while[count turtles < num-of-researchers] [

       ask links [ set color gray ]
       make-nodes find-partner

       tick
   ]
   if index = 0 [
       set index index + 1
       ask turtles [set breed normal
                    set color black
                   ]
   ]

   Sorting
   Set-Ping

   while [row < num-of-researchers] [

       let N matrix:get temp-Matrix row 1                   ;assign all-citations to N
       ask turtle row [set t-Citation N]                    ;assign N to t-Citation


       set N matrix:get temp-Matrix row 2                   ;assign article to N
       ask turtle row [set t-Article N]                     ;assign N to t-Article
       set total-Article total-Article + N

       set N matrix:get temp-Matrix row 3                   ;assign index to N
       ask turtle row [set t-IndexArticle N]                ;assign N to t-IndexArticle
       set total-IndexArticle total-IndexArticle + N

       set N matrix:get temp-Matrix row 4                   ;assign betweenness to N
       ask turtle row [set t-Betweenness N]                 ;assign N to t-Betweenness
       set total-Betweenness total-Betweenness + N


       set N matrix:get temp-Matrix row 5                   ;assign cluster to N
       ask turtle row [set t-Cluster N]                     ;assign N to t-Cluster
       set total-Cluster total-Cluster + N

       set N matrix:get temp-Matrix row 6                   ;assign n-of-connections
       ask turtle row [set t-Connection N]                  ;assign N to t-Connection
       set total-Connection total-Connection + N

       set N matrix:get temp-Matrix row 7                   ;assign n-degree
       ask turtle row [set t-Degree N]                      ;assign N to t-Degree
       set total-Degree total-Degree + N

       set row row + 1
   ]

   set no-of-sorting-level  no-of-sorting-level + 1

   if no-of-sorting-level > Max-Sorting-Level [
      stop
   ]

end



to Sorting

  repeat 3 [

    let factor sqrt count turtles

    layout-spring turtles links (1 / factor) (7 / factor) (1 / factor)
    display                     ;; for smooth animation
  ]

  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles

  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]

end




to Set-Ping

  set index 0

  if Select = "Articles" [                                      ;for articles basic color is lime
      set articleStep 333
      set connectionStep 828.4
      set degreeStep 9
      set betweennessStep 16765
      set clusterStep 226.8

      while [index < num-of-researchers] [
         let N matrix:get temp-Matrix index 2                   ;article value in file/matrix
         ask turtle index [
           ifelse N * 30 / 100 > 3
               [set Size 3 set color lime + N]
           [set Size N * 30 / 100 set color lime + N]

            set index index + 1
         ]

      ]

  ]

  if Select = "Betweenness" [                                   ;for betweenness basic color is blue
       set articleStep 300
       set connectionStep 800.4
       set degreeStep 8.5
       set betweennessStep 14765
       set clusterStep 206.8

       while [index < num-of-researchers] [
          let N matrix:get temp-Matrix index 4                  ;betweenness value in file/matrix
          ask turtle index [
              ifelse N * 30 / 100 > 3
                  [set Size 3 set color blue + N]
              [set Size N * 30 / 100 set color lime + N]

               set index index + 1
          ]
       ]
  ]

  if Select = "Cluster" [                                       ;for cluster basic color is red

       set articleStep 253
       set connectionStep 780.4
       set degreeStep 8.7
       set betweennessStep 13765
       set clusterStep 200.8

       while [index < num-of-researchers] [
          let N matrix:get temp-Matrix index 5                  ;cluster value in file/matrix
          ask turtle index [
              ifelse N * 30 / 100 > 3
                  [set Size 3 set color red + N]
              [set Size N * 30 / 100 set color lime + N]

               set index index + 1
          ]
       ]
  ]

  if Select = "Degree" [                                         ;for degree basic color is green

       set articleStep 259
       set connectionStep 728.4
       set degreeStep 8
       set betweennessStep 11765
       set clusterStep 190.8

       while [index < num-of-researchers] [
          let N matrix:get temp-Matrix index 6                    ;n-of-connections value in file/matrix
          ask turtle index [
              ifelse N * 30 / 100 > 3
                  [set Size 3 set color green + N]
              [set Size N * 30 / 100 set color lime + N]

              set index index + 1
          ]
       ]
  ]

  if Select = "Connection" [                                      ;for degree basic color is yellow

       set articleStep 3
       set connectionStep 8
       set degreeStep 0.9
       set betweennessStep 16
       set clusterStep 2

       while [index < num-of-researchers] [
          let N matrix:get temp-Matrix index 7                     ;n-degree value in file/matrix
          ask turtle index [
              ifelse N * 30 / 100 > 3
                  [set Size 3 set color yellow + N]
              [set Size (N * 99 / 100) + 1 set color lime + N]

              set index index + 1
          ]
      ]
  ]

end



to-report find-partner
  report [one-of both-ends] of one-of links
end


to-report limit-magnitude [number limit]
  if number > limit [ report limit ]
  if number < (- limit) [ report (- limit) ]
  report number
end


to-report fill-matrix [n m generator]
  report matrix:from-row-list n-values n [n-values m [runresult generator]]
end


to-report random-in-range [low high]
  report low + random (high - low + 1)
end


to Go

     Calculate
     Plt

     set elapsed-time elapsed-time + 1
     set currentYear currentYear + 1
     set index 0
     set indexArticle 0
     set indexConnection 0
     set indexDegree 0
     set indexBetweenness 0
     set indexCluster 0

     if currentYear  = 1428 [if Export-File [ write-report-in-file ] Stop]
     if elapsed-time = 30   [if Export-File [ write-report-in-file ] Stop]
end


to Calculate

  while [indexArticle < random-in-range Max-Performance-Article articleStep] [
        let per random-in-range 0 (num-of-researchers - 1)                        ;local variable for performance change

        if  random  100 < Article-Range [
            ask turtle per [ set t-Article t-Article + 1
                             let N matrix:get temp-Matrix per 2
                             ask turtle per [
                                 if (t-Article * 30 / 100) > 3 [set color lime + t-Article]
                             ]
            ]
        ]
        set indexArticle indexArticle + 1
  ]

  if random  100 < Article-Range [
       set total-Article total-Article + random-in-range 100 (total-Article / 10)
  ]


  while [indexConnection < random-in-range Max-Performance-Connection connectionStep] [
        let per random-in-range 0 (num-of-researchers - 1)

        if random  100 < Connection-Range [
            ask turtle per [ set t-Connection t-Connection + 1]
        ]
        set indexConnection indexConnection + 1
  ]

  if random  100 < Connection-Range [
        set total-Connection total-Connection + random-in-range 100 (total-Connection / 10)
  ]

  while [indexDegree < random-in-range Max-Performance-Degree degreeStep] [
        let per random-in-range 0 (num-of-researchers - 1)

        if random  100 < Degree-Range [
            ask turtle per [set t-Degree t-Degree + 0.9]
        ]
        set indexDegree indexDegree + 1
  ]

  if random  100 < Degree-Range [
          set total-Degree total-Degree + random-in-range 0.5 (total-Degree / 10)
  ]

  while [indexBetweenness < random-in-range Max-Performance-Betweenness betweennessStep] [
         let per random-in-range 0 (num-of-researchers - 1)

         if random  100 < Betweenness-Range [
            ask turtle per [set t-Betweenness t-Betweenness + 1]
         ]
         set indexBetweenness indexBetweenness + 1
   ]

   if random  100 < Betweenness-Range [
           set total-Betweenness total-Betweenness + random-in-range 0.5 (total-Betweenness / 10)
   ]

   while [indexCluster < random-in-range Max-Performance-Cluster clusterStep] [
         let per random-in-range 0 (num-of-researchers - 1)

         if random  100 < Cluster-Range [
            ask turtle per [set t-Cluster t-Cluster + 1]
         ]
         set indexCluster indexCluster + 1
   ]

   if random  100 < Cluster-Range [
           set total-Cluster total-Cluster + random-in-range 0.5 (total-Cluster / 10)
   ]

end


to write-report-in-file

   file-open "files/report.txt"
   file-print(word "t-Article  t-Betweenness  t-Cluster  t-Connection  N-Degree")

   set index 0

  while [index < num-of-researchers] [
      ask turtle index [
          file-type t-Article
          file-type(word " ")
          file-type t-Betweenness
          file-type(word " ")
          file-type t-Cluster
          file-type(word " ")
          file-type t-Connection
          file-type(word " ")
          file-type N-Degree
          file-print(word " ")
      ]
      set index index + 1
   ]

  file-close-all

end


to Plt

     ;; plot Articles Trend in two sections. Behavioral and Computational. Behavioral is based on Agent t-Article properties. Computational Model is calculated by the simulation
     set-current-plot "Articles Trend"

     set-current-plot-pen "Behavioral Model"
     Plot sum [t-Article] of Turtles

     set-current-plot-pen "Computational Model"
     Plot total-Article



     ;; plot Articles Trend in two sections. Behavioral and Computational. Behavioral is based on Agent t-Connection properties. Computational Model is calculated by the simulation
     set-current-plot "Connection Trend"

     set-current-plot-pen "Behavioral Model"
     Plot sum [t-Connection] of Turtles

     set-current-plot-pen "Computational Model"
     Plot total-Connection



     ;; plot Articles Trend in two sections. Behavioral and Computational. Behavioral is based on Agent t-Degree properties. Computational Model is calculated by the simulation
     set-current-plot "Degree Status"

     set-current-plot-pen "Behavioral Model"
     Plot sum [t-Degree] of Turtles

     set-current-plot-pen "Computational Model"
     Plot total-Degree



     ;; plot Articles Trend in two sections. Behavioral and Computational. Behavioral is based on Agent t-betweenness properties. Computational Model is calculated by the simulation
     set-current-plot "Betweenness Status"

     set-current-plot-pen "Behavioral Model"
     Plot sum [t-Betweenness] of Turtles

     set-current-plot-pen "Computational Model"
     Plot total-Betweenness


     ;; plot Articles Trend in two sections. Behavioral and Computational. Behavioral is based on Agent t-Cluster properties. Computational Model is calculated by the simulation
     set-current-plot "Cluster Status"

     set-current-plot-pen "Behavioral Model"
     Plot sum [t-Cluster] of Turtles

     set-current-plot-pen "Computational Model"
     Plot total-Cluster

end
@#$#@#$#@
GRAPHICS-WINDOW
193
10
747
565
-1
-1
6.0
1
10
1
1
1
0
1
1
1
-45
45
-45
45
0
0
1
ticks
30.0

BUTTON
11
10
183
43
NIL
Setup-Network
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
10
49
183
82
NIL
Sort-Network
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
10
337
184
382
Select
Select
"Articles" "Betweenness" "Cluster" "Degree" "Connection"
0

INPUTBOX
11
227
185
287
bgColor
105.0
1
0
Color

SWITCH
11
298
185
331
Change-Color-In-Run
Change-Color-In-Run
0
1
-1000

PLOT
1004
10
1468
228
Articles Trend
NIL
NIL
0.0
10.0
0.0
12200.0
true
true
"" ""
PENS
"Behavioral Model" 1.0 0 -13345367 true "" ""
"Computational Model" 1.0 0 -5298144 true "" ""

SLIDER
11
389
183
422
Article-Range
Article-Range
0
100
100.0
1
1
NIL
HORIZONTAL

MONITOR
755
12
860
57
Current Year
currentYear
17
1
11

SLIDER
10
134
182
167
Max-Sorting-Level
Max-Sorting-Level
0
300
300.0
1
1
NIL
HORIZONTAL

BUTTON
10
87
184
120
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
756
168
991
201
Max-Performance-Article
Max-Performance-Article
100
300
300.0
1
1
NIL
HORIZONTAL

SLIDER
758
372
992
405
Connection-Range
Connection-Range
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
757
208
992
241
Max-Performance-Connection
Max-Performance-Connection
0
828.4
828.0
1
1
NIL
HORIZONTAL

PLOT
1005
238
1468
443
Connection Trend
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Behavioral Model" 1.0 0 -13345367 true "" ""
"Computational Model" 1.0 0 -5298144 true "" ""

SLIDER
758
248
993
281
Max-Performance-Degree
Max-Performance-Degree
0
2
2.0
1
1
NIL
HORIZONTAL

SLIDER
758
493
989
526
Degree-Range
Degree-Range
0
100
100.0
1
1
NIL
HORIZONTAL

PLOT
1006
450
1469
656
Degree Status
NIL
NIL
0.0
10.0
0.0
300.0
true
true
"" ""
PENS
"Behavioral Model" 1.0 0 -13345367 true "" ""
"Computational Model" 1.0 0 -5298144 true "" ""

MONITOR
756
64
861
109
Elapsed Time
elapsed-time
17
1
11

PLOT
1475
10
1940
227
Betweenness Status
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Behavioral Model" 1.0 0 -13345367 true "" ""
"Computational Model" 1.0 0 -5298144 true "" ""

PLOT
1475
239
1938
442
Cluster Status
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Behavioral Model" 1.0 0 -13345367 true "" ""
"Computational Model" 1.0 1 -5298144 true "" ""

SLIDER
758
289
993
322
Max-Performance-Betweenness
Max-Performance-Betweenness
0
16765
16765.0
1
1
NIL
HORIZONTAL

SLIDER
757
452
990
485
Betweenness-Range
Betweenness-Range
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
758
330
991
363
Max-Performance-Cluster
Max-Performance-Cluster
0
226.8
226.0
1
1
NIL
HORIZONTAL

SLIDER
758
412
991
445
Cluster-Range
Cluster-Range
0
100
100.0
1
1
NIL
HORIZONTAL

MONITOR
756
116
861
161
Number of Researchers
num-of-researchers
17
1
11

SWITCH
10
176
182
209
Export-File
Export-File
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
             
             
