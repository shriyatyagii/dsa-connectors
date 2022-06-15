//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import { InstaConnectors } from "../../common/interfaces.sol";

contract SwapHelpers {
	/**
	 * @dev Instadapp Connectors Registry
	 */
	InstaConnectors internal constant instaConnectors =
		InstaConnectors(0x127d8cD0E2b2E0366D522DeA53A787bfE9002C14);

	/**
	 *@dev Swap using the dex aggregators.
	 *@param _connectors name of the connectors in preference order.
	 *@param _datas data for the swap cast.
	 */
	function _swap(string[] memory _connectors, bytes[] memory _datas)
		internal
		returns (
			bool success,
			bytes memory returnData,
			string memory connector
		)
	{
		uint256 _length = _connectors.length;
		require(_length > 0, "zero-length-not-allowed");
		require(_datas.length == _length, "calldata-length-invalid");

		for (uint256 i = 0; i < _length; i++) {
			(success, returnData) = instaConnectors
				.connectors(_connectors[i])
				.delegatecall(_datas[i]);
			if (success) {
				connector = _connectors[i];
				break;
			}
		}
	}
}
