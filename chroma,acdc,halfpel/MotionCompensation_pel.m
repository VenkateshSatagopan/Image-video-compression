function [Reconstructed_frame, MV] = MotionCompensation_pel(ref_im, MV, dec_err, a, b)
    
    ref_Y             = ref_im(:,:,1);
    ref_Cb            = ref_im(:,:,2);
    ref_Cr            = ref_im(:,:,3);
    [ nRows , nCols ] = size( ref_Y );
    predicted_img_Y   = zeros( nRows , nCols );
    predicted_img_Cb  = zeros( nRows , nCols );
    predicted_img_Cr  = zeros( nRows , nCols );
    count             = 0;
    step              = 8;  
    
    ref_Y(:,nCols+1)  = ref_Y(:,nCols-1);
    ref_Y(nRows+1,:)  = ref_Y(nRows-1,:);
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
%             % These indices specify the start and stop indices of the
%             % window. The window will go from row rILo to rIHi amd column
%             % cILo to cIHi
%             rILo               = rI - halfWinSize; % lower row index of window
%             rIHi               = rI + halfWinSize; % upper row index of window
%             cILo               = cI - halfWinSize; % lower column index of window
%             cIHi               = cI + halfWinSize; % upper column index of window
%             SSE_MIN = Inf;
            %flagConditionMet = false ;
            
             
            % Motion Vectors
            count = count + 1;
            X = MV(count,1);
            Y = MV(count,2);        
            
            
            % Predicted frame
            X_predicted = rI + X;
            Y_predicted = cI + Y;
            
%% 
            % without optimization
            
%             predicted_img_Y(rI:step+rI-1,cI:step+cI-1) = ref_img_Y(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
%             predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = ref_img_Cb(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
%             predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = ref_img_Cr(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
            
%%
            % with sub-pel accuracy
            
            if((mod(X,1) ==0) || (mod(Y,1) ==0))   
                predicted_img_Y(rI:step+rI-1,cI:step+cI-1)  = ref_Y(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
                predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = ref_Cb(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
                predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = ref_Cr(X_predicted:step+X_predicted-1,Y_predicted:step+Y_predicted-1);
            else
                predicted_img_Y(rI:step+rI-1,cI:step+cI-1)  = interpol_Y(X_predicted-a:step+X_predicted-a-1,Y_predicted-b:step+Y_predicted-b-1);
                predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = interpol_Cb(X_predicted-a:step+X_predicted-a-1,Y_predicted-b:step+Y_predicted-b-1);
                predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = interpol_Cr(X_predicted-a:step+X_predicted-a-1,Y_predicted-b:step+Y_predicted-b-1);
            end

%%
            % with quarter-pel accuracy
            
%             predicted_img_Y(rI:step+rI-1,cI:step+cI-1) = quarter_pel(ref_img_Y, X_predicted, Y_predicted, step, nCols, nRows);
%             predicted_img_Cb(rI:step+rI-1,cI:step+cI-1) = quarter_pel(ref_img_Cb, X_predicted, Y_predicted, step, nCols, nRows);
%             predicted_img_Cr(rI:step+rI-1,cI:step+cI-1) = quarter_pel(ref_img_Cr, X_predicted, Y_predicted, step, nCols, nRows);
 
         end
    end
    
    predicted_img(:,:,1) = predicted_img_Y;
    predicted_img(:,:,2) = predicted_img_Cb;
    predicted_img(:,:,3) = predicted_img_Cr;
    
    Reconstructed_frame = dec_err + predicted_img;     % All the components Y, Cb, Cr
    
    
end