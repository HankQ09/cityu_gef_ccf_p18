pragma solidity ^ 0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/cryptography/draft-EIP712.sol";

contract MyToken is ERC721, Ownable, EIP712, ERC721Votes {
    using Counters
    for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    bool proved_credentials = true; // whether or not user has completed ZKP
    
    constructor() ERC721("ASoulBoundToken", "SBT") EIP712("ASoulBoundToken", "1") {}
    
    function safeMint(address to) public onlyOwner {
        require(proved_credentials == true, "You must prove you can be issued this SBT first");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Be the owner of the token to burn it");
        _burn(tokenId);
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Votes) {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721) {
        require(from == address(0) || to == address(0), "Soul Bound Token is Non-Transferable!");
         // when token transfer is attempted, prevents the token from being transferred
        super._beforeTokenTransfer(from, to, tokenId);
    }
    // Attribution: https://docs.chainstack.com/docs/gnosis-tutorial-simple-soulbound-token-with-remix-and-openzeppelin
    // Attribution: https://blog.tally.xyz/how-to-create-a-soulbound-governance-token-in-5-minutes-or-less-4151d2164b9d    
    // Attribution: https://www.quicknode.com/guides/ethereum-development/smart-contracts/how-to-create-a-soulbound-token#creating-the-soulbound-token
}
