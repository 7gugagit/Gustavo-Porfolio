using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DustTrail : MonoBehaviour
{
    [SerializeField] ParticleSystem boardParticles;
    void OnCollisionEnter2D(Collision2D other) {
        if(other.gameObject.tag == "Floor") {
            boardParticles.Play();
        }
        
    }

    void OnCollisionExit2D(Collision2D other) {
        if(other.gameObject.tag == "Floor") {
            boardParticles.Stop();
        }
    }
}
