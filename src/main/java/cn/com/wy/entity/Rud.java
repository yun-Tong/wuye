package cn.com.wy.entity;

import java.util.List;

/**
 * 房间实体类
 */
public class Rud {
    private int rudId;
    private int rudRidId;  //栋
    private int rudUnId;  //单元
    private int rudDpId;    //门牌
    private String rudRidgepole; //栋
    private String rudUnit;  //单元名称
    private String rudDoorplate; //门牌号
    private Head head; //业主    n -- 1
    private List<PropertyFee> propertyFeeList; //物业费  1 -- n
}
