# Open Season ![lang][lng-image] ![proj][project-image] ![Lecture][Lecture-image] ![Year][Year-image]
> The ultimate hunting experience.  
  
![Logo](Logo.png)  

## Description  
This first person hunting game gives an expirience in pico-8 similar to the game Duck Hunt.  
Based on the Nintedo™ game Duck Hunt.  

[lng-image]: https://img.shields.io/badge/LNG-Lua-orange
[project-image]: https://img.shields.io/badge/Proj-Game_Dev-blue
[Lecture-image]: https://img.shields.io/badge/Lecture-Programmering_C-brown
[Year-image]: https://img.shields.io/badge/Year-2021-green

### Features
**Maps**    
* Jungle  
* Safari  
* Polar  

**Weapons**
* Double Barrel Shotgun
* Single Barrel Shotgun
* Rifle

**Animals**
* Parrot
* Monke
* Panda
* Bird
* Antilope
* Lion
* Pinguin
* Iron Seal
* Polar Bear

## Game Controls  
```Mouse:```         ```Aim```   
```Left Click:```    ```Shoot```  
```Right Click:```    ```Cock```  
```X / V / M:```          ```Reload```  
```Arrow Keys:```     ```Menu Navigation```    



## Idéer
### Skjulte Farver
![alt text](https://nerdyteachers.com/PICO-8/resources/img/reference/hidden_palette.png)

Farve kode: ```pal(col(udskift),col+128,1)```.

### Kode
#### Farver brugt med pall
Udskiftet - Med farve
* 12 - 12  (map1 og 2)
* 11 - 6 (map1)
* 2 - 10 
* 10 - 4
* 2 - 6
* 14 - 5
* 15 - 1

#### Settings print
```
draw_options={
  [1]=function() print() end,
  [2]=function() print() end,
  [3]=function() print() end,
  [4]=function() print() end,
  [5]=function() print() end,
  [6]=function() print() end} 
draw_options[settings]()```







