// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;
contract College{
    enum collStatus {Active, Inactive}
    struct college{
        string name;
        address coladd;
        string regno;
        collStatus cs;
    }
}
contract Student{
    struct student{
        address stuAddr;
        string sname;
        uint phno;
        string course;
    }
}
contract tracker is College,Student{
    address admin;
    event collegeAdded(address coladd, string name, string regno);
    event collegeActivated(address coladd, string name);
    event collegeDeactivated(address coladd, string name);
    event studentAdded(address stuAddr,string sname,uint phno,string course);
    mapping(address => college) internal coll;
    mapping (address=>student) internal stu;
    constructor(){
        admin = msg.sender;
    }
    modifier isAdmin(){
        require(msg.sender == admin);
        _;
    }
    modifier isActive(address add_){
        require(coll[add_].cs == collStatus.Active,"Active");
        _;
    }
    address[] internal colList;
    address[] internal stuList;
    function addCollege(college memory ca_)public isAdmin{
        require(coll[ca_.coladd].coladd == address(0), "college exists");
        coll[ca_.coladd] = ca_;
        colList.push(ca_.coladd);
        emit collegeAdded(ca_.coladd, ca_.name, ca_.regno);
    }
    function collegeDetails(address add_)public view returns(college memory){
        return coll[add_];
    }
    function blockCollege(address add_,bool status)public isAdmin returns(collStatus cs){ 
        require(coll[add_].coladd != address(0),"not found");
        if(!status && coll[add_].cs == collStatus.Inactive){
            coll[add_].cs = collStatus.Active;
            emit collegeActivated(add_, coll[add_].name);
            return collStatus.Active;
        }else if(status && coll[add_].cs == collStatus.Active){
            coll[add_].cs = collStatus.Inactive;
            emit collegeDeactivated(add_, coll[add_].name);
            return collStatus.Inactive;
        }
    }
    function addStudent(student memory st_)public{
            require(coll[msg.sender].cs == collStatus.Inactive, "College inactive");
            stu[st_.stuAddr] = st_;
            stuList.push(st_.stuAddr);
            emit studentAdded(st_.stuAddr,st_.sname,st_.phno,st_.course);
        
    }
    function studentDetails(address add_)public view returns(student memory){
        return stu[add_];
    }
    function changeCourse(address add_,string memory course_)public{
        stu[add_].course = course_;
    }
}