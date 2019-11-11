 function [err_im, MV] = MotionEstimation_pel(ref_im, current_image, a, b)
    Y                   = current_image(:,:,1);
    ref_Y               = ref_im(:,:,1);
    ref_Cb              = ref_im(:,:,2);
    ref_Cr              = ref_im(:,:,3);
    [ nRows , nCols ]   = size( Y );
    predicted_img_Y     = zeros( nRows , nCols );
    predicted_img_Cb    = zeros( nRows , nCols );
    predicted_img_Cr    = zeros( nRows , nCols );
    halfWinSize         = 4; 
    step                = 8;
    count               = 0;
    
    ref_Y(:,nCols+1) = ref_Y(:,nCols-1);
    ref_Y(nRows+1,:) = ref_Y(nRows-1,:);
    ref_Cb(:,nCols+1) = ref_Cb(:,nCols-1);
    ref_Cb(nRows+1,:) = ref_Cb(nRows-1,:);
    ref_Cr(:,nCols+1) = ref_Cr(:,nCols-1);
    ref_Cr(nRows+1,:) = ref_Cr(nRows-1,:);
%% Interpolated Y, Cb, Cr components
    for rI = 1:nRows
        for cI = 1:nCols
            
            interpol_Y(rI,cI) = (1-b)*(1-a)*ref_Y(rI,cI)+(1-b)*(a)*ref_Y(rI+1,cI)+(b)*(1-a)*ref_Y(rI,cI+1)+(a)*(b)*ref_Y(rI+1,cI+1);
            interpol_Cb(rI,cI) = (1-b)*(1-a)*ref_Cb(rI,cI)+(1-b)*(a)*ref_Cb(rI+1,cI)+(b)*(1-a)*ref_Cb(rI,cI+1)+(a)*(b)*ref_Cb(rI+1,cI+1);
            interpol_Cr(rI,cI) = (1-b)*(1-a)*ref_Cr(rI,cI)+(1-b)*(a)*ref_Cr(rI+1,cI)+(b)*(1-a)*ref_Cr(rI,cI+1)+(a)*(b)*ref_Cr(rI+1,cI+1);
            
        end
    end

    
    for rI = 1:step:nRows
        for cI = 1:step:nCols
            % These indices specify the start and stop indices of the
            % window. The window will go from row rILo to rIHi amd column
            % cILo to cIHi
            rILo               = rI - halfWinSize; % lower row index of window
            rIHi               = rI + halfWinSize; % upper row index of window
            cILo               = cI - halfWinSize; % lower column index of window
            cIHi               = cI + halfWinSize; % upper column index of window
            SSE_MIN = Inf;
            flagConditionMet = false ;
            
            % Current frame
            current_block = Y(rI:step+rI-1,cI:step+cI-1);
            X_current = rI;
            Y_current = cI; 
             
                  
            % while success criteria unmet
            while(  ~flagConditionMet )
                
                % It is important to make sure that your window indices are valid
                % indices before pulling out the window.            
                if( rILo >= 1 && rIHi <= nRows && cILo >= 1 && cIHi <= nCols )
                    
                    % Pull out the window around (rI , cI)
                    imgWindow = ref_Y((rILo:rIHi),(cILo:cIHi));
                    
                    if(((step+cILo-1) <= nCols) && ((step+rILo-1) <= nRows))
                                            
                        % Reference frame
                        ref_8x8 = ref_Y(rILo:step+rILo-1,cILo:step+cILo-1);
                        interpol_8x8 = interpol_Y(rILo:step+rILo-1,cILo:step+cILo-1);

                        %perform an operation
                        square_of_diff_orig = (ref_8x8 - current_block).^2;
                        square_of_diff_interpol = (interpol_8x8 - current_block).^2;
                        SSE_orig = sum(square_of_diff_orig(:));
                        SSE_interpol = sum(square_of_diff_interpol(:));
                    
                    end
                    
                    %check if successful
                    if(SSE_orig < SSE_MIN)
                        X_ref = rILo;
                        Y_ref = cILo;           %ref_Motion_coordinates
                        SSE_MIN = SSE_orig;
                    end
                    if(SSE_interpol < SSE_MIN)
                        X_ref = rILo+a;
                        Y_ref = cILo+b;           %ref_Motion_coordinates
                        SSE_MIN = SSE_interpol;
                    end
                                        
                end
            
                
                    cILo = cILo + 1;
                    if(cILo > cIHi)
                        cILo = cI - halfWinSize;
                        rILo = rILo + 1;
                        if(rILo > rIHi)
                            flagConditionMet = true;
                       end
                    end
                 
            end
             
            % Block Replacement
            count = count + 1;
            MV(count,1:2) = [X_ref-X_current , Y_ref-Y_current];        % Motion_Vector
            
%%
            % Without optimization
            
%             predicted_img_Y(rI:step+rI-1,cI:step+cI-1) = ref_Y(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
%             predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = ref_Cb(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
%             predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = ref_Cr(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
            
%%
            % with sub-pel accuracy
            
            if((mod(X_ref,1) ==0) || (mod(Y_ref,1) ==0))   
                predicted_img_Y(rI:step+rI-1,cI:step+cI-1)  = ref_Y(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
                predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = ref_Cb(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
                predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = ref_Cr(X_ref:step+X_ref-1,Y_ref:step+Y_ref-1);
            else
                predicted_img_Y(rI:step+rI-1,cI:step+cI-1)  = interpol_Y(X_ref-a:step+X_ref-a-1,Y_ref-b:step+Y_ref-b-1);
                predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = interpol_Cb(X_ref-a:step+X_ref-a-1,Y_ref-b:step+Y_ref-b-1);
                predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = interpol_Cr(X_ref-a:step+X_ref-a-1,Y_ref-b:step+Y_ref-b-1);
            end
           
         end
    end
    
    predicted_img(:,:,1) = predicted_img_Y;
    predicted_img(:,:,2) = predicted_img_Cb;
    predicted_img(:,:,3) = predicted_img_Cr;
    
    err_im = current_image - predicted_img;     % All the components Y, Cb, Cr
    
end