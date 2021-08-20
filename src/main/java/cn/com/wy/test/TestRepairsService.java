package cn.com.wy.test;

import cn.com.wy.dao.HeadDao;
import cn.com.wy.entity.Head;
import cn.com.wy.entity.Repairs;
import cn.com.wy.service.HeadService;
import cn.com.wy.service.RepairsService;
import org.junit.Before;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.junit.Test;

import java.sql.Date;
import java.util.List;

public class TestRepairsService {
    private RepairsService repairsService;
    private HeadDao headDao;
    @Before
    public void init(){
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
        repairsService = ctx.getBean(RepairsService.class);

    }

    /**
     * 查询全部
     */
    @Test
    public void findAll(){
        List<Repairs> repairsList = repairsService.findAll();
        for (Repairs repairs :repairsList) {
            System.out.println(repairs);
        }
    }

    /**
     * 根据户主id查询
     */
    @Test
    public  void findByHeadId(){
        List<Repairs> repairsLists = repairsService.findByHeadId(1);
        for (Repairs repairs :repairsLists) {
            System.out.println(repairs);
        }
    }

    /**
     * 根据编号查询
     */
    @Test
    public void findByRepId(){
        List<Repairs> repairsLists = repairsService.findByRepId(1);
        for (Repairs repairs :repairsLists) {
            System.out.println(repairs);
        }
    }

    /**
     * 新增
     */
    @Test
    public void addReq(){
        Repairs repairs = new Repairs();
        repairs.setRepIssue("一栋二楼电梯有声音");
        repairs.setRepState(1);
        Head head = new Head();
        head.setHeadId(1);
        repairs.setHead(head);
        repairs.setRepStartDate(new Date(2020-1900,8,07));
        repairs.setRepRemark("");
        boolean re = repairsService.addRep(repairs);
        System.out.println(re);
    }
    @Test
    public void updateReq(){

        Repairs repairs = new Repairs();
        repairs.setRepId(3);
        repairs.setRepIssue("二栋有声音");
        repairs.setRepState(3);
        repairs.setRepEndDate(new Date(120,7,12));
        boolean boo = repairsService.updateRep(repairs);
        System.out.println(repairs);
        System.out.println(boo);
    }
    @Test
    public void  deleteRep(){
        boolean boo = repairsService.deleteRep(2);
        System.out.println(boo);
    }
}
