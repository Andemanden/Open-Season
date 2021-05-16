# Open Season
The ultimate hunting experience.  
  
  
## Description  
This first person hunting game gives an expirience in pico-8 similar to the game Duck Hunt.  
Based on the Nintedo™ game Duck Hunt.  
  
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

https://www.youtube.com/watch?v=AsVzk6kCAJY&ab_channel=LazyDevs
### Kode
#### Farver brugt med pall
Udskiftet - Med farve
* 12 - 12
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

