function mos_num = getBin2Num_2dmos( mos_bin )

    mos_num = [];
    for i=1:size(mos_bin, 2)
        if (mos_bin(:,i) == [1;1])
            mos_num = [mos_num, 1];
        else
            if (mos_bin(:,i) == [1;0])
                mos_num = [mos_num, 2];
            else 
                if (mos_bin(:,i) == [0;1])
                    mos_num = [mos_num, 3];
                else
                    if (mos_bin(:,i) == [0;0])
                        mos_num = [mos_num, 4];
                    end
                end
            end
        end
    end
end

