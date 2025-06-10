package com.aziz.campusmarket.service.impl;

import com.aziz.campusmarket.config.JwtProvider;
import com.aziz.campusmarket.domain.AccountStatus;
import com.aziz.campusmarket.domain.USER_ROLE;
import com.aziz.campusmarket.exceptions.SellerException;
import com.aziz.campusmarket.modal.Address;
import com.aziz.campusmarket.modal.Seller;
import com.aziz.campusmarket.repository.AddressRepository;
import com.aziz.campusmarket.repository.SellerRepository;
import com.aziz.campusmarket.service.SellerService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SellerServiceImpl implements SellerService {

    private final SellerRepository sellerRepository;
    private final JwtProvider jwtProvider;
    private final PasswordEncoder passwordEncoder;
    private final AddressRepository addressRepository;

    @Override
    public Seller getSellerProfile(String jwt) throws Exception {

        String email = jwtProvider.getEmailFromJwtToken(jwt);

        return this.getSellerByEmail(email);
    }

    @Override
    public Seller createSeller(Seller seller) throws Exception {

        Seller sellerExist = sellerRepository.findByEmail(seller.getEmail());

        if (sellerExist != null) {
            throw new Exception("Email already used");
        }
        Address savedAddress = addressRepository.save(seller.getPickupaddress());

        Seller newSeller = new Seller();
        newSeller.setEmail(seller.getEmail());
        newSeller.setPassword(passwordEncoder.encode(seller.getPassword()));
        newSeller.setSellerName(seller.getSellerName());
        newSeller.setPickupaddress(savedAddress);
        newSeller.setFiscalCode(seller.getFiscalCode());
        newSeller.setRole(USER_ROLE.ROLE_SELLER);
        newSeller.setMobile(seller.getMobile());
        newSeller.setBankDetails(seller.getBankDetails());
        newSeller.setEmailVerified(true);
        newSeller.setPreferredName(seller.getPreferredName());

        return sellerRepository.save(newSeller);
    }

    @Override
    public Seller getSellerById(Long id) throws SellerException {
        return sellerRepository.findById(id).orElseThrow(() -> new SellerException("seller not found with the id " + id));
    }

    @Override
    public Seller getSellerByEmail(String email) throws Exception {

        Seller seller = sellerRepository.findByEmail(email);

        if (seller == null) {
            throw new Exception("Seller not found");
        }

        return seller;
    }

    @Override
    public List<Seller> getAllSellers(AccountStatus status) {

        return sellerRepository.findByAccountStatus(status);
    }

    @Override
    public Seller updateSeller(Long id, Seller seller) throws Exception {

        Seller existingSeller = this.getSellerById(id);

        if (seller.getSellerName() != null) {
            existingSeller.setSellerName(seller.getSellerName());
        }

        if (seller.getMobile() != null) {
            existingSeller.setMobile(seller.getMobile());
        }

        if (seller.getEmail() != null) {
            existingSeller.setEmail(seller.getEmail());
        }

        if (seller.getBankDetails() != null
                && seller.getBankDetails().getAccountHolderName() != null
                && seller.getBankDetails().getIban() != null
                && seller.getBankDetails().getAccountNumber() != null)
        {
            existingSeller.getBankDetails().setAccountNumber(seller.getBankDetails().getAccountNumber());
            existingSeller.getBankDetails().setAccountHolderName(seller.getBankDetails().getAccountHolderName());
            existingSeller.getBankDetails().setIban(seller.getBankDetails().getIban());
        }

        if (    seller.getPickupaddress() != null
                && seller.getPickupaddress().getAddress() != null
                && seller.getPickupaddress().getCity() != null
                && seller.getPickupaddress().getMobile() != null
                && seller.getPickupaddress().getState() != null
        ) {
            existingSeller.getPickupaddress().setAddress(seller.getPickupaddress().getAddress());
            existingSeller.getPickupaddress().setCity(seller.getPickupaddress().getCity());
            existingSeller.getPickupaddress().setMobile(seller.getPickupaddress().getMobile());
            existingSeller.getPickupaddress().setState(seller.getPickupaddress().getState());
            existingSeller.getPickupaddress().setPinCode(seller.getPickupaddress().getPinCode());
        }
        if (seller.getFiscalCode() != null) {
            existingSeller.setFiscalCode(seller.getFiscalCode());
        }

        return sellerRepository.save(existingSeller);
    }

    @Override
    public void deleteSeller(Long id) throws Exception {
        Seller seller = getSellerById(id);
        sellerRepository.delete(seller);
    }

    @Override
    public Seller verifyEmail(String email, String otp) throws Exception {
        Seller seller = getSellerByEmail(email);
        seller.setEmailVerified(true);

        return sellerRepository.save(seller);
    }

    @Override
    public Seller updateSellerAccountStatus(Long sellerId, AccountStatus status) throws Exception {
        Seller seller = getSellerById(sellerId);
        seller.setAccountStatus(status);

        return sellerRepository.save(seller);
    }
}
