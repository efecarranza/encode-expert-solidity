# Remove from an array without leaving gaps

```
uint256[] myList = [0,1,2,3,4,5,6,7,8];
function removeAt(uint256 index) public returns (uint256[] memory) {
    myList[index] = myList[myList.length - 1];
    myList.pop();
    return myList;
}
```
