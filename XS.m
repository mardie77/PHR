
classdef XS
    %XS Class refering to all Multispectral CCDs in Pleaides mission 
    %   Revision: 20.04.2017 
    %   Pleaides mission is a constellation of 2 satellites,
    %   PHR1A and PHR1B which provide images of high resolution of the
    %   Earth. 
    %   The insrument on each satellite is composed of 5 Panchromatic CCDs
    %   and 5 Multispectral CCDs (XS), with four spectral bands each:
    %   B0 = Blue
    %   B1 = Green
    %   B2 = Red
    %   B3 = Near Infrared
    
    properties (Constant) 
        N_pixels    = 1496;
    end
    
    properties (Hidden) % They are not shown with the object list
        GainsPHRB = [1.723 1.829 1.750 1.884 1.808 1.471 1.522 1.434 1.559 1.565 1.326 1.358 1.336 1.341 1.380 1.396 1.412 1.439 1.502 1.362]; % Gains for the ampli at the CCD output. There is 5 different gains (one for each CCD) and 4 different bands. This vector contains the gains in 1 - 5 order from B0 - B3.   
        GainsPHRA = [1.650 1.764 1.626 1.699 1.651 1.616 1.721 1.566 1.696 1.617 1.421 1.505 1.479 1.474 1.427 1.226 1.233 1.244 1.234 1.168];
        Kcan      = 4096/900e-3;  % Cte de conversion Analoguique - Numeric 
        Offset    = 31.5;     % Asservissement offset, 31.5 [LSB], utilise pour eviter del valeurs negatifs sur les données
        Sutile    = 2.704e-9;     % Surface utile du pixel = 52x52micrometres^2
        Sstockage = 750e-6;       % Surface de stockage = 750micrometres^2 avec une capacite de 3e5 - 4e5 electrons par V de puits
        Tligne    = 414e-6;       % Temps d'integration per ligne = 414microseconde (103,5 chaque bande) 
    end
    
    properties
        datePDV
        Satellite   % Which satellite 'PHR1A' or 'PHR1B'
        Mode        % Mode of view 'XS' or 'PAN'
        nLignes     %= 7256
        Temperature
        SourceImages
%         B0_1        
%         B0_2
%         B0_3
%         B0_4
%         B0_5
%         B1_1        
%         B1_2
%         B1_3
%         B1_4
%         B1_5
%         B2_1        
%         B2_2
%         B2_3
%         B2_4
%         B2_5
%         B3_1        
%         B3_2
%         B3_3
%         B3_4
%         B3_5
%         G_physical  = 11.8;
            
   
    end
    
    
    
          
   
    
    methods
        
        function obj = XS(PDV)
            
            % , N_samples, G_ampli, G_physical, Std_Dev
            %% loading XML files 
            xmlfile_1 = fullfile('sag_descripteur.xml');
            xDoc_1 = xmlread(xmlfile_1);
            xmlfile_2 = fullfile('PHRDIMAP.xml');
            xDoc_2 = xmlread(xmlfile_2);
            
            
            %% Properties of the object 
            obj.PDV = PDV;
            obj.Satellite = char(xDoc_1.getElementsByTagName('satellite').item(0).getTextContent);
            obj.Mode = char(xDoc_1.getElementsByTagName('modeTraitement').item(0).getTextContent);
            obj.N_samples = xDoc_1.getElementsByTagName('nbLignes').item(0).getTextContent;
            
            %% Getting the temperature 
            % Nombre de measures, normalement sont 39, mais pour la suequence longue sont autour de 20 
            temp_values = 20; 

            vect_temp_fp = zeros(1,temp_values);

                for i = 1 : temp_values
                    temp = str2double(xDoc_2.getElementsByTagName('TEMP_FP').item(i-1).getTextContent);
                    vect_temp_fp(1,i) = temp;
                end

            obj.Temperature = mean(vect_temp_fp);
        end
        
        % function hola = hot_pixel(Bande,XSccd,cte)
        
        
            %obj.Bande = char(strcat('B',num2str(Bande)));
            %obj.B0_1 = double(imread('IMG_B0_1.JP2'))-31.5;
            %obj.Image = imread(strcat('IMG_B',num2str(Bande),'_',num2str(XSccd),'.JP2'));
            
%                 %XSccd = 1; 
%                 %XSbande = 0;
% 
%                 %for bande = 0 : 3
%                     %for XSccd = 1 : 5
%                     image_jp2 = imread(strcat('IMG_B',num2str(Bande),'_',num2str(XSccd),'.JP2'));
%                     image_double = double(image_jp2);
%                     filename = strcat('B',num2str(Bande),'_',num2str(XSccd),'.txt');
%                     obj.filename = image_double - 31.5;

% %                   B(bande, XSccd) = image_jp2;  
% %                     filename = strcat('B',num2str(bande),'_',num2str(XSccd),'.txt');
% %                     dlmwrite(filename,image_double);
%                     %end
%                 %end 
            
            
          
            
            %% Gain of ampli search 
%             gain_number = 5*Bande + XSccd;
%             
%             if strcmp(obj.Satellite,'PHR1A') == true
%                 obj.G_amp = obj.All_Gains_A(gain_number);
%             else
%                 obj.G_amp = obj.All_Gains_B(gain_number);
%             end 
        
        
    end

     
end
