using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CrashDetector : MonoBehaviour
{

    [SerializeField] float sceneReloadDelay = 0.5f;
    [SerializeField] ParticleSystem crashEffect;
    [SerializeField] ParticleSystem boardEffect;
    [SerializeField] AudioClip crashSFX;
    bool hasCrashed = false;

    void OnTriggerEnter2D(Collider2D other)
    {
        Debug.Log(hasCrashed);
        if(other.tag == "Floor" && !hasCrashed) {
            GetComponent<AudioSource>().PlayOneShot(crashSFX);
            hasCrashed = true;
            FindObjectOfType<PlayerController>().DisableControls();
            crashEffect.Play();
            Invoke("ReloadScene", sceneReloadDelay);
        }
    }

    void ReloadScene() {
     SceneManager.LoadScene(0);
    }
}
