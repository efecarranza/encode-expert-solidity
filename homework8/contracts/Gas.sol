// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    uint256 public totalSupply; // cannot be changed
    uint256 public paymentCounter;
    uint256 public constant tradePercent = 12;
    uint256 public tradeMode;
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    mapping(address => uint256) public whitelist;
    mapping(address => bool) public isOddWhitelistUser;
    mapping(address => bool) public administrators;

    PaymentType constant DEFAULT_PAYMENT = PaymentType.Unknown;
    History[] public paymentHistory; // when a payment was updated

    struct Payment {
        uint256 paymentID;
        uint256 amount;
        address recipient;
        string recipientName; // max 8 characters
        bool adminUpdated;
        PaymentType paymentType;
        address admin; // administrators address
    }

    struct History {
        uint256 lastUpdate;
        uint256 blockNumber;
        address updatedBy;
    }
    struct ImportantStruct {
        uint16 valueA; // max 3 digits
        uint16 valueB; // max 3 digits
        uint256 bigValue;
    }

    mapping(address => ImportantStruct) public whiteListStruct;

    bool constant tradeFlag = true;
    bool constant basicFlag = false;
    bool constant dividendFlag = true;
    bool public isReady;
    bool wasLastOdd = true;
    address _owner = msg.sender;

    event AddedToWhitelist(address userAddress, uint256 tier);
    event SupplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    modifier onlyAdminOrOwner() {
        if (_owner != msg.sender || !checkForAdmin(msg.sender)) {
            revert("Error: only admin or owner allowed");
        }
        _;
    }

    modifier checkIfWhiteListed() {
        uint256 usersTier = whitelist[msg.sender];
        require(usersTier > 0, "Error: user is not whitelisted");
        require(usersTier < 4, "Error: invalid tier");
        _;
    }

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        for (uint256 i = 0; i < _admins.length; i++) {
            if (_admins[i] == address(0)) {
                continue;
            }
            administrators[_admins[i]] = true;
            if (_admins[i] == _owner) {
                balances[_owner] = totalSupply;
            }
            emit SupplyChanged(_admins[i], balances[_admins[i]]);
        }
    }

    function getPaymentHistory()
        public
        view
        returns (History[] memory paymentHistory_)
    {
        return paymentHistory;
    }

    function checkForAdmin(address _user) public view returns (bool) {
        return administrators[_user];
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        return tradeFlag || dividendFlag;
    }

    function addHistory(address _updateAddress, bool _tradeMode)
        public
        returns (bool status_, bool tradeMode_)
    {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        bool status = tradePercent > 0 ? true : false;
        return (status, _tradeMode);
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        require(_user != address(0), "Error: invalid address");
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        require(balances[msg.sender] >= _amount, "Sender has insufficient Balance");
        require(bytes(_name).length < 9, "Recipient name too long, max length of 8 characters");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        Payment memory payment = Payment(
            ++paymentCounter,
            _amount,
            _recipient,
            _name,
            false,
            PaymentType.BasicPayment,
            address(0)
        );
        payments[msg.sender].push(payment);

        emit Transfer(_recipient, _amount);

        if (tradePercent > 0) {
            return true;
        } else {
            return false;
        }
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        require(_ID > 0, "ID must be greater than 0");
        require(_amount > 0, "Amount must be greater than 0");
        require(_user != address(0),"Administrator must have a valid non zero address");

        for (uint256 i = 0; i < payments[_user].length; i++) {
            if (payments[_user][i].paymentID == _ID) {
                payments[_user][i].adminUpdated = true;
                payments[_user][i].admin = _user;
                payments[_user][i].paymentType = _type;
                payments[_user][i].amount = _amount;
                addHistory(_user, getTradingMode());
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    payments[_user][i].recipientName
                );
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        require(_tier > 0 && _tier < 4, "Tier level should be 1, 2 or 3");
        whitelist[_userAddrs] = _tier;

        if (wasLastOdd) {
            isOddWhitelistUser[_userAddrs] = wasLastOdd;
            wasLastOdd = false;
        } else if (!wasLastOdd) {
            delete isOddWhitelistUser[_userAddrs];
            wasLastOdd = true;
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public checkIfWhiteListed {
        require(balances[msg.sender] >= _amount, "Sender has insufficient Balance");
        require(_amount > 3, "Amount to send must be bigger than 3");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        balances[msg.sender] += whitelist[msg.sender];
        balances[_recipient] -= whitelist[msg.sender];

        ImportantStruct storage newImportantStruct;
        newImportantStruct.valueA = _struct.valueA;
        newImportantStruct.bigValue = _struct.bigValue;
        newImportantStruct.valueB = _struct.valueB;
        emit WhiteListTransfer(_recipient);
    }
}
