<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../common/header.jsp"%>
<div class="easyui-layout" data-options="fit:true">
    <!-- Begin of toolbar -->
    <div id="wu-toolbar">
        <div class="wu-toolbar-button">
            <%@include file="../common/menus.jsp"%>
        </div>
        <div class="wu-toolbar-search">
            <label>业主名称:</label>
            <select id="search-yezhu_id" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="">全部</option>
            	<c:forEach items="${yezhuList }" var="yezhu">
            	<option value="${yezhu.yezhu_id }">${yezhu.yz_name }</option>
            	</c:forEach>
            </select>
            <label>收费类型:</label>
            <select id="search-feetype_id" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="">全部</option>
            	<c:forEach items="${feetypeList }" var="feetype">
            	<option value="${feetype.feetype_id }">${feetype.feetype_name }</option>
            	</c:forEach>
            </select>
            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">搜索</a>
        </div>
    </div>
    <!-- End of toolbar -->
    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<!-- 添加账单弹框 -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
	<form id="add-form" method="post">
        <table>
            <tr>
                <td align="right">业主姓名:</td>
                <td>
                	<select id="add-yezhu_id" name="yezhu_id" class="easyui-combobox" panelHeight="auto" style="width:120px">
            			<c:forEach items="${yezhuList }" var="yezhu">
            				<option value="${yezhu.yezhu_id }">${yezhu.yz_name }</option>
            			</c:forEach>
               		</select>
                </td>
            </tr>
            <tr>
                <td align="right">开始日期:</td>
                <td><input type="text" id="add-start_date" name="start_date" class="wu-text easyui-datebox easyui-validatebox" /></td>
            </tr>
            <tr>
                <td align="right">结束日期:</td>
                <td><input type="text" id="add-final_date" name="final_date" class="wu-text easyui-datebox easyui-validatebox" /></td>
            </tr>
            <tr>
            	<td align="right">收费项目:</td>
            	<td>
            		<select id="add-feetype_id" name="feetype_id" class="easyui-combobox" panelHeight="auto" style="width:120px">
            			<c:forEach items="${feetypeList }" var="feetype">
            				<option value="${feetype.feetype_id }">${feetype.feetype_name }</option>
            			</c:forEach>
           			</select>
           		</td>
            </tr>
            <tr>
                <td align="right">缴费金额:</td>
                <td><input type="text" id="add-fee_money" name="fee_money" class="wu-text easyui-validatebox" /></td>
            </tr>
			<tr>
                <td align="right">备注:</td>
                <td><textarea id="add-remark" name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
            </tr>
        </table>
    </form>
</div>

<%@include file="../common/footer.jsp"%>
<!-- End of easyui-dialog -->
<script type="text/javascript">
	
	/**
	*  添加记录
	*/
	function add(){
		var validate = $("#add-form").form("validate");
		if(!validate){
			$.messager.alert("消息提醒","请检查你输入的数据!","warning");
			return;
		}
		var data = $("#add-form").serialize();
		$.ajax({
			url:'add',
			dataType:'json',
			type:'post',
			data:data,
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert('信息提示','添加成功！','info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				}else{
					$.messager.alert('信息提示',data.msg,'warning');
				}
			}
		});
	}

	
	
	/**
	* 删除记录
	*/
	function remove(){
		$.messager.confirm('信息提示','确定要删除该记录？', function(result){
			if(result){
				var item = $('#data-datagrid').datagrid('getSelected');
				if(item == null || item.length == 0){
					$.messager.alert('信息提示','请选择要删除的数据！','info');
					return;
				}
				$.ajax({
					url:'delete',
					dataType:'json',
					type:'post',
					data:{fee_id:item.fee_id},
					success:function(data){
						if(data.type == 'success'){
							$.messager.alert('信息提示','删除成功！','info');
							$('#data-datagrid').datagrid('reload');
							$('#data-datagrid').datagrid('unselectAll');
						}else{
							$.messager.alert('信息提示',data.msg,'warning');
						}
					}
				});
			}	
		});
	}
	
	
	/**
	* Name 打开添加窗口
	*/
	function openAdd(){
		//$('#add-form').form('clear');
		$('#add-dialog').dialog({
			closed: false,
			modal:true,
            title: "添加报修信息",
            buttons: [{
                text: '确定',
                iconCls: 'icon-ok',
                handler: add
            }, {
                text: '取消',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#add-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	$("#add-form input").val('');
            	
            }
        });
	}
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		var option = {yezhu_id:$("#search-yezhu_id").combobox('getValue')};
		var feetype_id = $("#search-feetype_id").combobox('getValue');
		if(feetype_id != -1){
			option.feetype_id = feetype_id;
		}
		$('#data-datagrid').datagrid('reload',option);
		$('#data-datagrid').datagrid('unselectAll');
	});
	/** 
	* 载入数据
	*/
	$('#data-datagrid').datagrid({
		url:'list',
		rownumbers:true,
		singleSelect:false,
		pageSize:20,           
		pagination:true,
		multiSort:true,
		fitColumns:true,
		idField:'id',
	    treeField:'name',
		fit:true,
		columns:[[
			{ field:'chk',checkbox:true},
			{ field:'yezhu_id',title:'业主姓名',width:100,formatter:function(value,row,index){
				var yezhuList = $("#search-yezhu_id").combobox('getData');
				for(var i=0;i<yezhuList.length;i++){
					if(yezhuList[i].value == value)
						return yezhuList[i].text;
				}
				}},
			{ field:'start_date',title:'开始日期',width:100,sortable:true},
			{ field:'final_date',title:'结束日期',width:100,sortable:true},
			{ field:'feetype_id',title:'收费类型',width:100,formatter:function(value,row,index){
				var feetypeList = $("#search-feetype_id").combobox('getData');
				for(var i=0;i<feetypeList.length;i++){
					if(feetypeList[i].value == value)
						return feetypeList[i].text;
				}
				}},
			{ field:'fee_money',title:'缴费金额',width:130,sortable:true},
			{ field:'fee_photo',title:'支付凭证',width:130,align:'center',formatter:function(value,row,index){
				var img = '<img src="'+value+'" width="50px" style="margintop:5px" />';
				return img;
				}
			},
			{ field:'status',title:'状态',width:100,formatter:function(value,row,index){
				switch(value){
					case 0:{
						return '已处理';
					}
					case 1:{
						return '缴费中';
					}
					case 2:{
						return '已缴纳';
					}
				}
				return value;
			}},
			{ field:'remark',title:'备注',width:200,sortable:true},
		]]
	});
</script>