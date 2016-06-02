

								E-Shopper Theme 
							   author : Brainstation-23
							  powered by: nopCommerce



About 'E-Shopper' & Installation Process :



1. 'E-Shopper' theme is released for nopCommerce 3.20 and nopCommerce 3.30 and nopCommerce 3.4

2. 'NopShop' directory contains views and contents.

3. To activate 'E-Shopper' theme copy that 'NopShop' folder of the particular version and paste it to the 'Themes' folder of your server.

4. Go to admin panel of your site and go to Configuration -> Settings -> General and Miscellaneous Settings.

5. Select 'NopShop' among the 'Desktop store theme' options and save.



i) Remove Theme color chooser from version nopCommerce 3.3 and nopCommerce 3.4

	answer : In this version of 'NopShop' theme, a theme color chooser is added. But initially it is hidden by commenting out few lines, because most of the people don't want to use the theme color scheme chooser. If anyone want to add it back to their page, please follow the instructions-

	1. Open 'Head.cshtml' file on '~/Themes/NopRoot/Views/Shared/Head.cshtml' directry.

	2. For nopCommerce 3.3 uncomment lines 31-37 and 79-85 . 

	3. For nopCommerce 3.4 uncomment lines 31-37 and 84-90 .

	4. Open 'TopMenu.cshtml' file on '~/Themes/NopRoot/Views/Catalog/TopMenu.cshtml' directry.

	5. For nopCommerce 3.3 uncomment lines 29-111.

	6. For nopCommerce 3.4 uncomment lines 29-111.

ii)Add Different color in 'NopShop' theme

	answer : Initially 'NopShop' theme has 'Orange' color but it contains 'Red', 'Green', 'Blue', 'Dark Blue' and 'Cyan' colors to match your branding. Follow the following steps to choose any color that you want- 
	
	1. Open 'Head.cshtml' file on '~/Themes/NopShop/Views/Shared/Head.cshtml' directry.
	
	2. For nopCommerce 3.4 only Uncomment line 10 & 52 and comment others for 'Black' color,	
						
						line 14 & 56 and comment others for 'Blue' color,
						
						line 17 & 59 and comment others for 'Red' color,

						line 20 & 62 and comment others for 'Green' color,

						line 24 & 66 and comment others for 'Dark Blue'color,

						line 2 & 69 and comment others for 'Cyan' color

	3. For nopCommerce 3.4 only Uncomment line 10 & 52 and comment others for 'Black' color,	
						
						line 14 & 56 and comment others for 'Blue' color,
						
						line 17 & 59 and comment others for 'Red' color,

						line 20 & 62 and comment others for 'Green' color,

						line 24 & 66 and comment others for 'Dark Blue'color,

						line 2 & 69 and comment others for 'Cyan' color


	----------------Initially We uncommented 'Orange' color for you because black is the brand color of 'NopRoot'----------------------------










                                     ````                                             
                                     ````````                                         
                              ``       `````  ``                                      
                             ``````     ````     ``                                   
                           ``````````    `````     ``                                 
                          `...........   `.....`                                      
                         `.............   ........`                                   
                        `..............   ...........                                 
                        ...............   ............                                
                       ................   .............                               
                       ................   .............`                              
                      ................   ...............                              
                      ................   ...............                              
                      ,,,,,,,,,,,,,,,`  `,,,,,,,,,,,,,,,`                             
                      `.,,,,,,,,,,,,,   ,,,,,,,,,,,,,,,,,                             
                         `,,,,,,,,,,.   ,,,,,,,,,,,,,,,,,                             
                            ,,,,,,,,   ,,,,,,,,,,,,,,,,,,                             
                     ,,`      `,,,.    ,,,,,,,,,,,,,,,,,,                             
                     ,,,,,            ,,,,`  ,,,,,,,,,,,,                             
                     ,,,,,,,.       `,,,,,    ,,,,,,,,,,,                             
                     :::::::::,` `.::::::`     .:::::::::                             
                     :::::::::::::::::::::        ,:::::,                             
                     .:::::::::::::::::::::.,`      `..                               
                      :::::::::::::::::::::::::.                                      
                      ::::::::::::::::::::::::::::                                    
                      .:::::::::::::::::::::::::::::                                  
                       ::::::::::::::::::::::::::::::                                 
                       .:::::::::::::::::::::::::::::,                                
                        ::::::::::::::::::::::::::::::                                
                         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                 
                          ;;;;;;;;;;;;;;;;;;;;;;;;;;`                                 
                           ;;;;;;;;;;;;;;;;;;;;;;;;`                                  
                            ;;;;;;;;;;;;;;;;;;;;;;                                    
                             ,;: .;;;;;;;;;;;;;;:                                     
                               ,:   :;;;;;;;;;:                                       
                                 `:.  `;;;;:.                                         
                                    .:                                                
                                      `                                               
                                                                                      
   `.`    ..                       .,                        ,,                       
  ,@@@@` @@@@;  #@@  ;@ @@: `@    @@@@+@@@@@ `@@  @@@@@;@# ,@@@@` @@  :@   ::::. :::: 
  ,@  @+ @. #@  @:@  ;@ @@@ `@   '@     +@   ;@@;   @'  @# @@  @@ @@# :@   `  ::    :`
  ,@ `@, @. @@  @ @` ;@ @#@;`@   ;@;    +@   @+@@   @'  @#.@`  ;@ @;@`:@      ,:   .: 
  ,@@@#  @@@@` '@ @# ;@ @#'@ @    #@@.  +@   @`:@   @'  @#;@   .@`@'@@.@      :,  ::. 
  ,@  @@ @;+@` @@@@@ ;@ @# @:@      @@  +@  .@@@@.  @'  @#:@`  :@`@'`@,@     ::    `:.
  ,@  @@ @. @# @+++@ ;@ @# ;@@      .@` +@  #@++@+  @'  @# @'  #@ @' @@@    ::      ::
  ,@,+@' @. @@.@`  @:;@ @#  @@   ;#'@@  +@  @#  @@  @'  @# #@+#@; @' `@@   ::,,, :.::`
  .#@#,  +. :+'+   ++:+ ++  :+   ,#@+   '+  +.  ,+  +;  +'  ;@@,  +;  ++   ,,,,, ,::` 
                                                                                      

